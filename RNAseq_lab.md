# RNA seq. Pipeline

Login info: **ssh aadas@bluemoon-user2.uvm.edu**

### Location of our file (*Brachyleytrum aristosum* data)

**Treatment:** There are three replicates for "pre-treatment" (1-3x), three for 24 h cold shock (4-6y), and two for 6 wk cold (7-8z). Not the perfect data set but okay given the species.

```
[aadas@bluemoon-user2 ~]$ cd /gpfs2/scratch/djshirle/MPS/170216_SNL128_0151_AHC72LBCXY/samples_out/
[aadas@bluemoon-user2 samples_out]$ ll
total 144
-rw-r--r-- 1 djshirle usr 2504 Feb 24 16:16 170216_demux_sheet-Preston.csv.quality_table_by_lane.txt
-rw-r--r-- 1 djshirle usr 2488 Feb 24 16:16 170216_demux_sheet-Preston.csv.quality_table_by_sample.txt
drwxr-xr-x 4 djshirle usr 8192 Feb 24 16:11 Ba1x
drwxr-xr-x 4 djshirle usr 8192 Feb 24 15:58 Ba2x
drwxr-xr-x 4 djshirle usr 8192 Feb 24 16:04 Ba3x
drwxr-xr-x 4 djshirle usr 8192 Feb 24 15:59 Ba4y
drwxr-xr-x 4 djshirle usr 8192 Feb 24 16:06 Ba5y
drwxr-xr-x 4 djshirle usr 8192 Feb 24 16:00 Ba6y
drwxr-xr-x 4 djshirle usr 8192 Feb 24 16:03 Ba7z
drwxr-xr-x 4 djshirle usr 8192 Feb 24 15:58 Ba8z
```

Let's open Ba1x

```
[aadas@bluemoon-user2 samples_out]$ cd Ba1x/
[aadas@bluemoon-user2 Ba1x]$ ll
total 10661240
drwxr-xr-x 4 djshirle usr        512 Feb 24 16:11 jcpresto_BrArisVR_20170217_Ba1x_R1_fastqc
-rw-r--r-- 1 djshirle usr     197928 Feb 24 16:11 jcpresto_BrArisVR_20170217_Ba1x_R1_fastqc.zip
-rw-r--r-- 1 djshirle usr 5399685374 Feb 24 15:41 jcpresto_BrArisVR_20170217_Ba1x_R1.fastq.gz
-rw-r--r-- 1 djshirle usr        157 Feb 24 15:43 jcpresto_BrArisVR_20170217_Ba1x_R1.fastq.gz.md5sum
drwxr-xr-x 4 djshirle usr        512 Feb 24 16:10 jcpresto_BrArisVR_20170217_Ba1x_R2_fastqc
-rw-r--r-- 1 djshirle usr     201979 Feb 24 16:10 jcpresto_BrArisVR_20170217_Ba1x_R2_fastqc.zip
-rw-r--r-- 1 djshirle usr 5517001528 Feb 24 15:45 jcpresto_BrArisVR_20170217_Ba1x_R2.fastq.gz
-rw-r--r-- 1 djshirle usr        157 Feb 24 15:46 jcpresto_BrArisVR_20170217_Ba1x_R2.fastq.gz.md5sum
```



#### Trimming script 

```
#!/bin/bash

######## This job needs 1 nodes, 2 processors total
#PBS -l nodes=1:ppn=2
# it needs to run for 6 hours
#PBS -l walltime=06:00:00
#PBS -N renamer
#PBS -j oe
#PBS -M YOUR_ACCOUNT@uvm.edu
#PBS -m bea
###LOAD JAVA MODULE AVAILABLE FROM THE CLUSTER, YOU MAY WANT TO CHECK FIRST
module load java-sdk/sun-jdk-1.6.0.12
ulimit -s unlimited
###CHANGE THE DIRECTORY ACCORDINGLY, THE FOLLOWING SETTINGS ARE FOR MY ACCOUNT
SOFTWARE=/users/j/z/jzhong2/bin/Trimmomatic-0.33/
workDIR=/users/j/z/jzhong2/scratch/wheat_polyploidization
cd $workDIR
#####TRIMMING COMMANDS AND PARAMETERS
java -jar $SOFTWARE/trimmomatic-0.33.jar PE -phred33 $workDIR/Melica6weekcold01.R1.fq $workDIR/Melica6weekcold01.R2.fq $workDIR/Melica6weekcold01_R1.trimmo.fq $workDIR/Melica6weekcold01_R1.unpaired.fq $workDIR/Melica6weekcold01_R2.trimmo.fq $workDIR/Melica6weekcold01_R2.unpaired.fq ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:40
```



