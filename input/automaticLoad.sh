#!/bin/bash

rm -rf $JBROWSE_DATA;
mkdir -p $JBROWSE_DATA/raw/;

CHROMOSOMES="2R 2L 3R 3L X"
POPULATIONS="RAL ZI"
PAIRPOPS="RAL_ZI ZI_RAL"
POPTEST="pi theta fst"
# POPTEST="pi theta"

declare -A COLORS=( ["RAL"]="#ab2710" ["ZI"]="#e2bd9a" )
declare -A METAPOP=( ["RAL"]="AM" ["ZI"]="AFR" )


if [ ! -e $JBROWSE_DATA/raw/dmel ]; then
    # ln -s $DATA_DIR/dmel/ $JBROWSE_DATA/raw/dmel;
    ln -s $DATA_DIR/dmel/ $JBROWSE_DATA/raw/tracks;
fi;
ln -sf $DATA_DIR/dmel.json $JBROWSE_DATA/raw/;



# Reference sequenes
for NCHR in ${CHROMOSOMES}
do
    prepare-refseqs.pl --fasta $DATA_DIR/dmel/refseq/Chr${NCHR}.fasta 
done

# sed 's/"key"\ :\ "Reference sequence"/"key"\ :\ "Assembly 5.57"/g' $JBROWSE_DATA/trackList.json;

biodb-to-json.pl -v --conf $DATA_DIR/dmel.json --out $JBROWSE_DATA;

# # Tracks by chr
# for NCHR in ${CHROMOSOMES}
# do
#     echo ${NCHR}
#     flatfile-to-json.pl --trackType CanvasFeatures --trackLabel gene_annotations --autocomplete all --gff $DATA_DIR/dmel/annotations/${NCHR}.gff3 --key "Gene annotations" --metadata '{"general_tracks":"Gene annotations"}' 
 
# done

for TEST in ${POPTEST}
do

    if [ ${TEST} == 'fst' ];then

        SUBCAT="Variation / Population diferentiation"
        for POP in ${PAIRPOPS}
        do
            echo $SUBCAT
            echo ${POP}
            add-bw-track.pl --category "${SUBCAT}" \
                            --label "${POP}_${TEST}_10kb" \
                            --plot \
                            --pos_color "${COLORS[$POP]}" \
                            --bw_url /data/raw/tracks/${TEST}/${POP}_${TEST}_10kb.bw \
                            --config '{"metadata":{ "population":'\"${POP}\"',"metapopulation":'\"${METAPOP[${POP}]}\"',"freq_nucleotide_variation":'\"${TEST}\"',"window_size":"10kb","description":"Nucleotide diversity: average number of nucleotide differences per site between any two sequences (Jukes and Cantor 1969; Nei and Gojobori 1986; Nei 1987)"}}' 
            
            printf "\n[tracks.${POP}_${TEST}_10kb]\ncategory=${SUBCAT}\nstoreClass=JBrowse/Store/SeqFeature/BigWig\n"
        done
    else

        SUBCAT='Variation / freq_nucleotide_variation'
        for POP in ${POPULATIONS}
        do
            echo ${POP}
            add-bw-track.pl --category "${SUBCAT}" \
                            --label "${POP}_${TEST}_10kb" \
                            --plot \
                            --pos_color "${COLORS[$POP]}" \
                            --bw_url /data/raw/tracks/${TEST}/${POP}_${TEST}_10kb.bw \
                            --config '{"metadata":{ "population":'\"${POP}\"',"metapopulation":'\"${METAPOP[${POP}]}\"',"freq_nucleotide_variation":'\"${TEST}\"',"window_size":"10kb","description":"Nucleotide diversity: average number of nucleotide differences per site between any two sequences (Jukes and Cantor 1969; Nei and Gojobori 1986; Nei 1987)"}}' 
            
            printf "\n[tracks.${POP}_${TEST}_10kb]\ncategory=${SUBCAT}\nstoreClass=JBrowse/Store/SeqFeature/BigWig\n"
        done
    fi

done
add-json.pl '{ "dataset_id": "dmel", "include": [ "functions.conf" ] }' \
    $JBROWSE_DATA/trackList.json
cp $DATA_DIR/dmel/functions.conf                  $JBROWSE_DATA/functions.conf

generate-names.pl --safeMode -v --out $JBROWSE_DATA;

