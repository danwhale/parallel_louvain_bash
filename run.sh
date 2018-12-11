#!/bin/bash
	N=32
	for filename in ./bank_lou/*.csv; do

		metis=$filename.metis		
		#python ./parallel-louvain-modularity/src/tools/txt2metis/txt2metis.py $filename $metis
                START=$(date +%s.%N)
		gpmetis $metis $N
		./parallel-louvain-modularity/src/parallel/convert -i $filename -o $filename'_o' -p $metis'.part.'$N -n $N
		mpirun -np $N ./parallel-louvain-modularity/src/parallel/community $filename'_o' -r $filename'_o' -l 1 -v
    		END=$(date +%s.%N)
    		DIFF=$(echo "$END - $START" | bc)
		echo $filename $DIFF >> ./resbnaks.txt
	done
