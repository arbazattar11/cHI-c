# cHi-C Data Analysis Pipeline

This pipeline provides a step-by-step workflow for processing and analyzing cHi-C (Circular Chromosome Conformation Capture) data. It includes quality control, read trimming, alignment, filtering, contact matrix construction, normalization, visualization, and interaction analysis.

## Prerequisites

Ensure the following tools are installed and accessible in your `PATH`:

- FastQC
- Trimmomatic
- BWA
- SAMtools
- Picard
- HiC-Pro
- HiCExplorer
- Juicebox
- Python 3

You also need a reference genome and associated files (e.g., restriction sites and digest files for HiC-Pro).

## Directory Structure

- `raw_data`: Directory containing raw FASTQ files.
- `trimmed_data`: Directory for storing trimmed reads.
- `alignments`: Directory for storing aligned BAM files.
- `filtered`: Directory for storing filtered BAM files.
- `contact_matrix`: Directory for storing contact matrices.
- `normalized_matrix`: Directory for storing normalized matrices.
- `visualization`: Directory for storing visualization outputs.

## Usage

1. **Set Up the Directories**:
    Ensure the necessary directories exist or create them:

    ```bash
    mkdir -p raw_data trimmed_data alignments filtered contact_matrix normalized_matrix visualization
    ```

2. **Prepare Reference Genome**:
    Ensure the reference genome file (`reference_genome.fa`) and related files (e.g., restriction sites, digest files) are available.

3. **Run the Script**:
    Save the pipeline script as `chi-c_analysis_pipeline.sh` and make it executable:

    ```bash
    chmod +x chi-c_analysis_pipeline.sh
    ./chi-c_analysis_pipeline.sh
    ```

## Script Breakdown

### Step 1: Quality Control

Run `FastQC` on raw FASTQ files to generate quality reports.

### Step 2: Read Trimming

Use `Trimmomatic` to remove adapter sequences and low-quality bases from the reads.

### Step 3: Alignment

Align trimmed reads to the reference genome using `BWA`.

### Step 4: Filtering

Filter out low-quality alignments and duplicates using `SAMtools` and `Picard`.

### Step 5: Contact Matrix Construction

Construct a contact matrix using `HiC-Pro`.

### Step 6: Normalization

Normalize the contact matrix using `HiCExplorer`.

### Step 7: Visualization

Visualize the contact matrix using `Juicebox`.

### Step 8: Interaction Analysis

Identify TADs and other interactions using `HiCExplorer`.

## Notes

- Modify the paths and parameters in the script as needed.
- Ensure all input files (e.g., FASTQ files, reference genome, restriction sites) are correctly specified.
- The pipeline assumes paired-end cHi-C data; for single-end data, adjustments might be needed.

## References

- [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)
- [BWA](http://bio-bwa.sourceforge.net/)
- [SAMtools](http://www.htslib.org/)
- [Picard](http://broadinstitute.github.io/picard/)
- [HiC-Pro](https://github.com/nservant/HiC-Pro)
- [HiCExplorer](https://hicexplorer.readthedocs.io/en/latest/)
- [Juicebox](https://github.com/aidenlab/Juicebox)

## License

This project is licensed under the MIT License - see the LICENSE file for details.
