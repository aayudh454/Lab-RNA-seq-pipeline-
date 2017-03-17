# RNA seq. Pipeline

Login info: 



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



