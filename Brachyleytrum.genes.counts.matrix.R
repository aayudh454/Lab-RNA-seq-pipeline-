library(cluster)
library(Biobase)
library(qvalue)
NO_REUSE = F

# try to reuse earlier-loaded data if possible
if (file.exists("Brachyleytrum.genes.counts.matrix.RData") && ! NO_REUSE) {
    print('RESTORING DATA FROM EARLIER ANALYSIS')
    load("Brachyleytrum.genes.counts.matrix.RData")
} else {
    print('Reading matrix file.')
    primary_data = read.table("Brachyleytrum.genes.counts.matrix", header=T, com='', sep="\t", row.names=1, check.names=F)
    primary_data = as.matrix(primary_data)
}
source("/gpfs1/home/a/a/aadas/Bin/trinityrnaseq-2.1.1/Analysis/DifferentialExpression/R/heatmap.3.R")
source("/gpfs1/home/a/a/aadas/Bin/trinityrnaseq-2.1.1/Analysis/DifferentialExpression/R/misc_rnaseq_funcs.R")
source("/gpfs1/home/a/a/aadas/Bin/trinityrnaseq-2.1.1/Analysis/DifferentialExpression/R/pairs3.R")
data = primary_data
samples_data = read.table("samples_described.txt", header=F, check.names=F, fill=T)
samples_data = samples_data[samples_data[,2] != '',]
sample_types = as.character(unique(samples_data[,1]))
rep_names = as.character(samples_data[,2])
data = data[, colnames(data) %in% samples_data[,2], drop=F ]
nsamples = length(sample_types)
sample_colors = rainbow(nsamples)
names(sample_colors) = sample_types
sample_type_list = list()
for (i in 1:nsamples) {
    samples_want = samples_data[samples_data[,1]==sample_types[i], 2]
    sample_type_list[[sample_types[i]]] = as.vector(samples_want)
}
sample_factoring = colnames(data)
for (i in 1:nsamples) {
    sample_type = sample_types[i]
    replicates_want = sample_type_list[[sample_type]]
    sample_factoring[ colnames(data) %in% replicates_want ] = sample_type
}
# reorder according to sample type.
tmp_sample_reordering = order(sample_factoring)
data = data[,tmp_sample_reordering,drop=F]
sample_factoring = sample_factoring[tmp_sample_reordering]
data = data[,colSums(data)>=10]
data = data[rowSums(data)>=10,]
initial_matrix = data # store before doing various data transformations
data = log2(data+1)
sample_factoring = colnames(data)
for (i in 1:nsamples) {
    sample_type = sample_types[i]
    replicates_want = sample_type_list[[sample_type]]
    sample_factoring[ colnames(data) %in% replicates_want ] = sample_type
}
sampleAnnotations = matrix(ncol=ncol(data),nrow=nsamples)
for (i in 1:nsamples) {
  sampleAnnotations[i,] = colnames(data) %in% sample_type_list[[sample_types[i]]]
}
sampleAnnotations = apply(sampleAnnotations, 1:2, function(x) as.logical(x))
sampleAnnotations = sample_matrix_to_color_assignments(sampleAnnotations, col=sample_colors)
rownames(sampleAnnotations) = as.vector(sample_types)
colnames(sampleAnnotations) = colnames(data)
data = as.matrix(data) # convert to matrix
write.table(data, file="Brachyleytrum.genes.counts.matrix.minCol10.minRow10.log2.dat", quote=F, sep='	');
pdf("Brachyleytrum.genes.counts.matrix.minCol10.minRow10.log2.principal_components.pdf")
data = as.matrix(data)
# Z-scale the genes across all the samples for PCA
prin_comp_data = data
for (i in 1:nrow(data)) {
    d = data[i,]
    d_mean = mean(d)
    d  = d - d_mean
    d = d / sd(d)
    prin_comp_data[i,] = d
}

pc = princomp(prin_comp_data, cor=TRUE)
pc_pct_variance = (pc$sdev^2)/sum(pc$sdev^2)
def.par <- par(no.readonly = TRUE) # save default, for resetting...
gridlayout = matrix(c(1:4),nrow=2,ncol=2, byrow=TRUE);
layout(gridlayout, widths=c(1,1));
write.table(pc$loadings, file="Brachyleytrum.genes.counts.matrix.minCol10.minRow10.log2.ZscaleRows.PC.loadings", quote=F, sep="	")
write.table(pc$scores, file="Brachyleytrum.genes.counts.matrix.minCol10.minRow10.log2.ZscaleRows.PC.scores", quote=F, sep="	")
for (i in 1:(max(3,2)-1)) {
    xrange = range(pc$loadings[,i])
    yrange = range(pc$loadings[,i+1])
    samples_want = rownames(pc$loadings) %in% sample_type_list[[sample_types[1]]]
    pc_i_pct_var = sprintf("(%.2f%%)", pc_pct_variance[i]*100)
    pc_i_1_pct_var = sprintf("(%.2f%%)", pc_pct_variance[i+1]*100)
    plot(pc$loadings[samples_want,i], pc$loadings[samples_want,i+1], xlab=paste('PC',i, pc_i_pct_var), ylab=paste('PC',i+1, pc_i_1_pct_var), xlim=xrange, ylim=yrange, col=sample_colors[1])
    for (j in 2:nsamples) {
        samples_want = rownames(pc$loadings) %in% sample_type_list[[sample_types[j]]]
        points(pc$loadings[samples_want,i], pc$loadings[samples_want,i+1], col=sample_colors[j], pch=j)
    }
    plot.new()
    legend('topleft', as.vector(sample_types), col=sample_colors, pch=1:nsamples, ncol=2)
}

par(def.par)
pcscore_mat_vals = pc$scores[,1:3]
pcscore_mat = matrix_to_color_assignments(pcscore_mat_vals, col=colorpanel(256,'purple','black','yellow'), by='row')
colnames(pcscore_mat) = paste('PC', 1:ncol(pcscore_mat))
dev.off()
gene_cor = NULL
