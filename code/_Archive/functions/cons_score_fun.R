function(alignment, wtVec, seqAnno, seq, lb, scores){
  
  # alignment: DNAStringSet object containing aligned sequences. First seq
  #           should be master
  # wtVec: weights to use for each sequence in the alignment
  # seqAnno: Annotated master sequence (all TFBS == '-')
  # seq: master sequence
  # lb: threshold for counting a bp as "conserved" (e.g. .5)
  # scores: (bin) return bp by bp scores if 1, else return consensus seq
  
  seqL <- nchar(seqAnno)
  nSeq <- length(alignment)-1
  
  #char matrix containing comparison seqs
  AlgnMat <- matrix(unlist(strsplit(paste0(alignment),NULL)), ncol = seqL, byrow = TRUE)
  AlgnMat <- AlgnMat[2:nrow(AlgnMat),]
  
  IndVec <- as.vector(gregexpr('-',seqAnno)[[1]]) #locations of TFBS
  CharVec <- unlist(strsplit(seq,NULL)) 
  CharMat <- t(matrix(rep(CharVec,nSeq), nrow=seqL))
  
  wtMat <- matrix(rep(wtVec,seqL), nrow=length(wtVec))
  wtDenom <- colSums(wtMat)
  
  wtScore <- colSums((AlgnMat==CharMat)*wtMat)/wtDenom
  wtScore[IndVec] <- 1.5 #ensure all known TFBS sites are preserved
  es2 <- DNAString(seq)
  es2cons <- es2[wtScore>=lb]
  if (scores==1){
    return(wtScore)
  }
  else{
    return(es2cons)
  }
}