
# Directories
RAW_DATA_DIR="raw_data"
TRIMMED_DATA_DIR="trimmed_data"
ALIGNMENT_DIR="alignments"
FILTERED_DIR="filtered"
CONTACT_MATRIX_DIR="contact_matrix"
NORMALIZED_MATRIX_DIR="normalized_matrix"
VISUALIZATION_DIR="visualization"

# Tools and Resources
FASTQC="fastqc"
TRIMMOMATIC="trimmomatic"
BWA="bwa"
SAMTOOLS="samtools"
PICARD="picard"
HIC_PRO="HiC-Pro"
HIC_EXPLORER="hicExplorer"
JUICEBOX="juicebox"
PYTHON="python3"

# Reference Genome
REFERENCE_GENOME="reference_genome.fa"

# Step 1: Quality Control
mkdir -p $RAW_DATA_DIR/QC
$FASTQC $RAW_DATA_DIR/*.fastq -o $RAW_DATA_DIR/QC

# Step 2: Read Trimming
mkdir -p $TRIMMED_DATA_DIR
for file in $RAW_DATA_DIR/*.fastq; do
  base=$(basename $file .fastq)
  $TRIMMOMATIC SE -phred33 $file $TRIMMED_DATA_DIR/${base}_trimmed.fastq ILLUMINACLIP:adapter.fasta:2:30:10 SLIDINGWINDOW:4:20 MINLEN:50
done

# Step 3: Alignment
mkdir -p $ALIGNMENT_DIR
for file in $TRIMMED_DATA_DIR/*.fastq; do
  base=$(basename $file _trimmed.fastq)
  $BWA mem $REFERENCE_GENOME $file | $SAMTOOLS view -Sb - > $ALIGNMENT_DIR/${base}.bam
done

# Step 4: Filtering
mkdir -p $FILTERED_DIR
for file in $ALIGNMENT_DIR/*.bam; do
  base=$(basename $file .bam)
  $SAMTOOLS view -q 30 -b $file | $SAMTOOLS sort - | $PICARD MarkDuplicates I=/dev/stdin O=$FILTERED_DIR/${base}_filtered.bam M=${base}_metrics.txt REMOVE_DUPLICATES=true
  $SAMTOOLS index $FILTERED_DIR/${base}_filtered.bam
done

# Step 5: Contact Matrix Construction
mkdir -p $CONTACT_MATRIX_DIR
$HIC_PRO -i $FILTERED_DIR -o $CONTACT_MATRIX_DIR -c config-hicpro.txt

# Step 6: Normalization
mkdir -p $NORMALIZED_MATRIX_DIR
$HIC_EXPLORER hicNormalize -m $CONTACT_MATRIX_DIR/raw_matrix.h5 --normalize small --outFileName $NORMALIZED_MATRIX_DIR/normalized_matrix.h5

# Step 7: Visualization
mkdir -p $VISUALIZATION_DIR
$JUICEBOX dump observed NONE $CONTACT_MATRIX_DIR/merged_nodups.txt $REFERENCE_GENOME $VISUALIZATION_DIR/observed.txt
$JUICEBOX hic_map $VISUALIZATION_DIR/observed.txt $VISUALIZATION_DIR/visualization.png

# Step 8: Interaction Analysis
$HIC_EXPLORER hicFindTADs -m $NORMALIZED_MATRIX_DIR/normalized_matrix.h5 --outPrefix $VISUALIZATION_DIR/TADs
$HIC_EXPLORER hicPlotTADs -m $NORMALIZED_MATRIX_DIR/normalized_matrix.h5 --outFileName $VISUALIZATION_DIR/TADs.pdf --TADs $VISUALIZATION_DIR/TADs.bed

echo "cHi-C analysis pipeline complete!"
