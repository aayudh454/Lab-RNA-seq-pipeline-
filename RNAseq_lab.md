# RNA seq. Pipeline

### Author: Aayudh Das

Login info: **ssh aadas@bluemoon-user2.uvm.edu**

### Data structure (*Brachyleytrum aristosum* data)

**Treatment:** There are three replicates for "pre-treatment" (1-3x), three for 24 h cold shock (4-6y), and two for 6 wk cold (7-8z). Not the perfect data set but okay given the species.

## Table of contents    
* [Page 1: 2017-03-20](#id-section1). Moving files and trimming 

* [Page 2: 2017-03-23](#id-section2). Trimming Ba2-3x, Ba4-6y, Ba7-8z

* [Page 3 2017-03-24](#id-section3). Concatenation and assembly (using Trinity 2.4.0)

* [Page 4 2017-03-28](#id-section4). Assembly using Trinity 2.0.6 

  ​

------
<div id='id-section1'/>
###Page 1: 2017-03-20. Moving files, basics and trimming

#### 1. Where are our files?

After login you should **cd** space the location path. **ll** to see what are the files present

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

#### 2. How can you move all the files to your own directory from the server?

```
[aadas@bluemoon-user2 ~]$ cp -r /gpfs2/scratch/djshirle/MPS/170216_SNL128_0151_AHC72LBCXY/samples_out/* . &
```

cp=copy, *= means everything (for individual file just write the name of the file instead of *)

#### 3. You need to install trimmomatic in your PC

go to http://www.usadellab.org/cms/?page=trimmomatic

right click on binary and copy link address 

```
[aadas@bluemoon-user2 ~]$ wget -c http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip
```

Now it's downloaded to your main directory as a zip file (Trimmomatic-0.36.zip)

you need to **unzip**

```
[aadas@bluemoon-user2 ~]$ unzip Trimmomatic-0.36.zip 
```

then you will see Trimmomatic-0.36 in your directory

#### 4. Create a new folder (command=mkdir) where you will execute all your analysis

```
[aadas@bluemoon-user2 ~]$ mkdir Ba
```

my new folder is Ba

#### 5. Let's see what files are present in Ba1x folder "pre-treatment" (1x)

```
[aadas@bluemoon-user2 ~]$ cd Ba1x/
[aadas@bluemoon-user2 Ba1x]$ ll
total 10661240
drwxr-xr-x 4 aadas usr        512 Mar 20 11:57 jcpresto_BrArisVR_20170217_Ba1x_R1_fastqc
-rw-r--r-- 1 aadas usr     197928 Mar 20 11:57 jcpresto_BrArisVR_20170217_Ba1x_R1_fastqc.zip
-rw-r--r-- 1 aadas usr 5399685374 Mar 20 11:56 jcpresto_BrArisVR_20170217_Ba1x_R1.fastq.gz
-rw-r--r-- 1 aadas usr        157 Mar 20 11:56 jcpresto_BrArisVR_20170217_Ba1x_R1.fastq.gz.md5sum
drwxr-xr-x 4 aadas usr        512 Mar 20 11:57 jcpresto_BrArisVR_20170217_Ba1x_R2_fastqc
-rw-r--r-- 1 aadas usr     201979 Mar 20 11:57 jcpresto_BrArisVR_20170217_Ba1x_R2_fastqc.zip
-rw-r--r-- 1 aadas usr 5517001528 Mar 20 11:57 jcpresto_BrArisVR_20170217_Ba1x_R2.fastq.gz
-rw-r--r-- 1 aadas usr        157 Mar 20 11:57 jcpresto_BrArisVR_20170217_Ba1x_R2.fastq.gz.md5sum
```

Now you need **R1.fastq.gz** and  **R2.fastq.gz** files, so copy them to your Ba folder. **../Ba/** = this means your are moving to Ba folder. **Ba1x_precold.R1.fastq.gz** is the new name.

```
[aadas@bluemoon-user2 Ba1x]$ cp jcpresto_BrArisVR_20170217_Ba1x_R1.fastq.gz ../Ba/Ba1x_precold.R1.fastq.gz
[aadas@bluemoon-user2 Ba1x]$ cp jcpresto_BrArisVR_20170217_Ba1x_R2.fastq.gz ../Ba/Ba1x_precold.R2.fastq.gz
```

Now in your Ba folder you have both the R1 and R2 files-

```
[aadas@bluemoon-user2 Ba]$ ll
total 10660840
-rw-r--r-- 1 aadas usr 5399685374 Mar 20 12:21 Ba1x_precold.R1.fastq.gz
-rw-r--r-- 1 aadas usr 5517001528 Mar 20 12:25 Ba1x_precold.R2.fastq.gz
```

#### 6. Now create a script for running the trimming program

you should be in your **Ba** folder 

```
[aadas@bluemoon-user2 ~]$ cd Ba/
[aadas@bluemoon-user2 Ba]$
```

 Now to create a blank script

```
[aadas@bluemoon-user2 ~]$ vi trimmomatic.sh
```

Now press **i** to insert 

Copy and paste everything present in the new script from this sample one

```
#!/bin/bash

######## This job needs 1 nodes, 2 processors total
#PBS -l nodes=1:ppn=2
# it needs to run for 6 hours
#PBS -l walltviime=06:00:00
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

and **esc**, **:wq** to save and quit. 

**:q!** only quit without saving.

look how I edited the things

```
#!/bin/bash

######## This job needs 1 nodes, 2 processors total
#PBS -q poolmemq
#PBS -l nodes=1:ppn=2,mem=16gb,vmem=18gb
# it needs to run for 6 hours
#PBS -l walltime=06:00:00
#PBS -N renamer
#PBS -j oe
#PBS -M aadas@uvm.edu
#PBS -m bea
###LOAD JAVA MODULE AVAILABLE FROM THE CLUSTER, YOU MAY WANT TO CHECK FIRST
ulimit -s unlimited
###CHANGE THE DIRECTORY ACCORDINGLY, THE FOLLOWING SETTINGS ARE FOR MY ACCOUNT
SOFTWARE=/users/a/a/aadas/Trimmomatic-0.36
workDIR=/users/a/a/aadas/Ba
cd $workDIR
#####TRIMMING COMMANDS AND PARAMETERS
java -jar $SOFTWARE/trimmomatic-0.36.jar PE -phred33 $workDIR/Ba1x_precold.R1.fastq.gz $workDIR/Ba1x_precold.R2.fastq.gz $workDIR/Ba1x_precold.R1.trimmo.fq.gz $workDIR/Ba1x_precold.R1.unpaired.fq.gz $workDIR/Ba1x_precold.R2.trimmo.fq.gz $workDIR/Ba1x_precold.R2.unpaired.fq.gz ILLUMINACLIP:TruSeq3-PE-2.fa:2:30:10 LEADING:20 TRAILING:20 SLIDINGWINDOW:5:20 MINLEN:40
```

i. You need to check **Submitting Jobs to the Cluster**-

https://www.uvm.edu/~vacc/?Page=userguide.php

first part of the script explains that details

ii. Now you need to specify where your software is present i.e. the Trimmomatic-0.36 which is in your main directory **/users/a/a/aadas/Trimmomatic-0.36**

iii. Specify your working directory-**/users/a/a/aadas/Ba** (because your R1 and R2 files are in Ba)

iv. TRIMMING COMMANDS AND PARAMETERS

a. change software version from as **trimmomatic-0.36**

b. Now the **first 2 files are your input file**, so after $workDIR/"name of the file" space [here R1 and R2 is the main change]

c. Last 4 files are **output files**.  

$workDIR/Ba1x_precold_R1.trimmo.fq.gz $workDIR/Ba1x_precold.R1.unpaired.fq.gz $workDIR/Ba1x_precold.R2.trimmo.fq.gz $workDIR/Ba1x_precold.R2.unpaired.fq.gz

for 1st pair one is paired named as R1.**trimmo** and R1.**unpaired**. same for the second pair.

#### 7. Make your script executable

you should be the folder where you saved your script

```
[aadas@bluemoon-user2 Ba]$ chmod 700 trimmomatic.sh
```

**700**=file's owner may read, write, and execute the file.

#### 8. Submit your job and check status of your job

```
[aadas@bluemoon-user2 Ba]$ qsub trimmomatic.sh 
```

check status

```
[aadas@bluemoon-user2 Ba]$ showq -u aadas
```

all jobs

```
[aadas@bluemoon-user2 Ba]$ showq
```
hang on there it's gonna take 6hrs. You can submit multiple jobs.

-----
<div id='id-section2'/>
### Page 2: 2017-03-23. Trimming Ba2-3x, Ba4-6y, Ba7-8z 

###### Some moving tips 

#### Rename a file

```
mv oldname newname
mv *.trimmo.fq.gz ../Brachyleytrum_aristosum
```

#### Moving Ba2x,Ba3x file to Ba folder

```
[aadas@bluemoon-user2 ~]$ cd Ba2x/
[aadas@bluemoon-user2 Ba2x]$ cp jcpresto_BrArisVR_20170217_Ba2x_R1.fastq.gz ../Ba/Ba2x_precold.R1.fastq.gz
[aadas@bluemoon-user2 Ba2x]$ cp jcpresto_BrArisVR_20170217_Ba2x_R2.fastq.gz ../Ba/Ba2x_precold.R2.fastq.gz

```

#### Now edit the script -

```
[aadas@bluemoon-user2 ~]$ cd Ba/
[aadas@bluemoon-user2 Ba]$ ll
[aadas@bluemoon-user2 Ba]$ vi trimmomatic.sh 
```

replace the Ba1x with Ba2x. Then :wq to save

#### Now make the script execute the task 

```
[aadas@bluemoon-user2 Ba]$ chmod 700 trimmomatic.sh 
```

#### Submit the job and view

```
[aadas@bluemoon-user2 Ba]$ qsub trimmomatic.sh
[aadas@bluemoon-user2 Ba]$ showq -u aadas
```

#### Copy only the trimmo.fq.gz files to a new folder for assembly

```
[aadas@bluemoon-user2 Ba]$ cp *.trimmo.fq.gz ../Brachyleytrum_aristosum
```



------

<div id='id-section3'/>

### Page 3: 2017-03-24. Concatenation and assembly

###### Some tips

to delete a line: **esc** and **d+d**

https://www.cs.colostate.edu/helpdocs/vi.html

Save all the commands as a history.txt

```
[aadas@bluemoon-user2 ~]$ history > history.txt
```

#### 1. Install trinity (using Trinity 2.4.0) 

Go to - https://github.com/trinityrnaseq/trinityrnaseq/releases and then copy link address of **Source code (tar.gz)**

```
[aadas@bluemoon-user2 ~]$ wget https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.4.0.tar.gz
```

Now create a new directory and move Trinity to that

```
[aadas@bluemoon-user2 ~]$ mkdir Bin
[aadas@bluemoon-user2 ~]$ mv Trinity-v2.4.0.tar.gz Bin/
```

unzip the tar file

```
[aadas@bluemoon-user2 Bin]$ tar -zxvf Trinity-v2.4.0.tar.gz
```

- -z: Compress the archive with g**z**ip.
- x ; decompress or extraction
- -v: Display progress in the terminal while creating the archive, also known as “**v**erbose” mode. The v is always optional in these commands, but it’s helpful.
- -f: Allows you to specify the **f**ilename of the archive.

now install 

```
[aadas@bluemoon-user2 Bin]$ cd trinityrnaseq-Trinity-v2.4.0/
[aadas@bluemoon-user2 trinityrnaseq-Trinity-v2.4.0]$ make 
```

but when downloading Trinity v2.0.6

````
[aadas@bluemoon-user2 trinityrnaseq-2.0.6]$ make plugins
````

#### 2. Execute concatenation for both R1 and R2

```
[aadas@bluemoon-user2 Brachyleytrum_aristosum]$ zcat *R1.trimmo.fq.gz > BrachyletrumARI.R1.trimmo.fq &
[aadas@bluemoon-user2 Brachyleytrum_aristosum]$ zcat *R2.trimmo.fq.gz > BrachyletrumARI.R2.trimmo.fq &
```

#### After finishing the concatenation check the "sequence header for both R1 and R2"-it should be same

```
[aadas@bluemoon-user2 Brachyleytrum_aristosum]$ grep -c "@" BrachyletrumARI.R1.trimmo.fq 
[aadas@bluemoon-user2 Brachyleytrum_aristosum]$ grep -c "@" BrachyletrumARI.R2.trimmo.fq 
```

both shows 168097158; That means R1 and R2 has same reads.

#### 3. Make sure you have a script to do the assembly 

```
#!/bin/bash

#PBS -l nodes=1:ppn=8,mem=96G,vmem=100G
#PBS -q poolmemq
# it needs to run for 6 hours
#PBS -l walltime=30:00:00
#PBS -N trinity
#PBS -j oe
#PBS -M aadas@uvm.edu
#PBS -m bea
module load samtools-1.3.1-gcc-6.3.0-e5jw5u4
module load bowtie2-2.2.5-gcc-6.3.0-daskah5
ulimit -s unlimited

SOFTWAREDIR=/users/a/a/aadas/Bin/trinityrnaseq-Trinity-v2.4.0
WORKINGDIR=/users/a/a/aadas/Brachyleytrum_aristosum
cd $WORKINGDIR

$SOFTWAREDIR/Trinity --seqType fq --max_memory 96G --left $WORKINGDIR/AegilopsLON_reads1.fastq --right $WORKINGDIR/AegilopsLON_reads2.fastq --CPU 8
```

edit the script (change WORKINGDIR file names)

```
#!/bin/bash

#PBS -l nodes=1:ppn=16,mem=96G,vmem=100G
#PBS -q poolmemq
# it needs to run for 6 hours
#PBS -l walltime=30:00:00
#PBS -N trinity
#PBS -j oe
#PBS -M aadas@uvm.edu
#PBS -m bea
module load samtools-1.3.1-gcc-6.3.0-e5jw5u4
module load bowtie2-2.2.5-gcc-6.3.0-daskah5
ulimit -s unlimited

SOFTWAREDIR=/users/a/a/aadas/Bin/trinityrnaseq-Trinity-v2.4.0
WORKINGDIR=/users/a/a/aadas/Brachyleytrum_aristosum
cd $WORKINGDIR

$SOFTWAREDIR/Trinity --seqType fq --max_memory 96G --left $WORKINGDIR/BrachyletrumARI.R1.trimmo.fq --right $WORKINGDIR/BrachyletrumARI.R2.trimmo.fq --CPU 16
```

Here you need to include the module load but first you need to check what modules are availble in the cluster.

```
[aadas@bluemoon-user2 Brachyleytrum_aristosum]$ module avail
```

Then include the samtools and bowtie version, so that your script can use that program.

Increase the cpu load to 16 in **ppn=16** and also in the end **CPU 16** 

Submit the job and view

```
[aadas@bluemoon-user2 Brachyleytrum_aristosum]$ qsub vacctrinity.sh 
[aadas@bluemoon-user2 Brachyleytrum_aristosum]$ showq -u aadas
```

If you see that 30% completed after 30hrs then qsub again and it will catch up from where it was left before.

------

<div id='id-section4'/>

### Page 4: 2017-03-28. Assembly using Trinity 2.0.6

Check the assembly file

```
# number of sequence present
[aadas@bluemoon-user2 trinity_out_dir]$ grep ">" Trinity.fasta | less
[aadas@bluemoon-user2 trinity_out_dir]$ grep ">" Trinity.fasta | sed "s/_i[0-9]\{1,2\} len.*//g" | less
[aadas@bluemoon-user2 trinity_out_dir]$ grep ">" Trinity.fasta | sed "s/_i[0-9]\{1,2\} len.*//g" | sort -u | less
[aadas@bluemoon-user2 trinity_out_dir]$ grep ">" Trinity.fasta | sed "s/_i[0-9]\{1,2\} len.*//g" | sort -u | wc -l
```

94102

check no. of seq

```
[aadas@bluemoon-user2 trinity_out_dir]$ grep ">" Trinity.fasta -c
```

567758

#### New script for assembly (Trinity 2.0.6) 

```
#!/bin/bash

#PBS -l nodes=1:ppn=16,mem=96G,vmem=128G
#PBS -q poolmemq
# it needs to run for 6 hours
#PBS -l walltime=30:00:00
#PBS -N trinity
#PBS -j oe
#PBS -M aadas@uvm.edu
#PBS -m bea
module load samtools-1.3.1-gcc-6.3.0-e5jw5u4

export PATH="/users/a/a/aadas/Bin/bowtie-1.2:$PATH"
export PATH="/users/a/a/aadas/Bin/jre1.7.0_80/bin:$PATH"
export PATH="/users/a/a/aadas/Bin/jre1.7.0_80/bin/java:$PATH"

ulimit -s unlimited

SOFTWAREDIR=/users/a/a/aadas/Bin_Trinity206/trinityrnaseq-2.0.6
WORKINGDIR=/users/a/a/aadas/Brachyleytrum_aristosum
cd $WORKINGDIR

$SOFTWAREDIR/Trinity --seqType fq --max_memory 96G --left $WORKINGDIR/BrachyletrumARI.R1.trimmo.fq --right $WORKINGDIR/BrachyletrumARI.R2.trimmo.fq --CPU 16
```

##### When you download something in mac and upload that to server

```
scp bowtie-1.2-linux-x86_64.zip aadas@bluemoon-user2.uvm.edu:~/
```

##### Delete an entire directory

```
rm -rf filename
```

### Running assembly with Trinity 2.1.1

```
#!/bin/bash

#PBS -l nodes=1:ppn=24,mem=256G,vmem=288G
#PBS -q poolmemq
# it needs to run for 6 hours
#PBS -l walltime=30:00:00
#PBS -N trinity
#PBS -j oe
#PBS -M aadas@uvm.edu
#PBS -m bea
module load samtools-1.3.1-gcc-6.3.0-e5jw5u4

export PATH="/users/a/a/aadas/Bin/bowtie-1.2:$PATH"
export PATH="/users/a/a/aadas/Bin/jre1.7.0_80/bin:$PATH"
export PATH="/users/a/a/aadas/Bin/jre1.7.0_80/bin/java:$PATH"

ulimit -s unlimited

SOFTWAREDIR=/users/a/a/aadas/Bin/trinityrnaseq-2.1.1
WORKINGDIR=/users/a/a/aadas/Brachyleytrum_aristosum
cd $WORKINGDIR

$SOFTWAREDIR/Trinity --seqType fq --max_memory 256G --left $WORKINGDIR/BrachyletrumARI.R1.trimmo.fq --right $WORKINGDIR/BrachyletrumARI.R2.trimmo.fq --CPU 24
```

 

#### First time before you execute the job with a new Trinity version

```
  936  2017-04-05 10:28:20 module load samtools-1.3.1-gcc-6.3.0-e5jw5u4
  937  2017-04-05 10:28:32 export PATH="/users/a/a/aadas/Bin/bowtie-1.2:$PATH"
  938  2017-04-05 10:28:40 export PATH="/users/a/a/aadas/Bin/jre1.7.0_80/bin:$PATH"
  939  2017-04-05 10:28:46 export PATH="/users/a/a/aadas/Bin/jre1.7.0_80/bin/java:$PATH"
  940  2017-04-05 10:29:10 cd ..
  941  2017-04-05 10:29:19 cd Bin/
  942  2017-04-05 10:29:20 ll
  943  2017-04-05 10:29:32 cd trinityrnaseq-Trinity-v2.3.2
  944  2017-04-05 10:29:35 make
  945  2017-04-05 10:34:06 cd ~/
```







