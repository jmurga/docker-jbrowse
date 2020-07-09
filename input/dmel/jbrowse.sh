#!/bin/bash

##### jbrowse.sh

#### step by step jbrowse configuration!!!

set -e 

######################################################################
### 1) REFERENCE SEQUENCES

bin/prepare-refseqs.pl --fasta files/refseq/Chr2L.fasta && bin/prepare-refseqs.pl --fasta files/refseq/Chr2R.fasta && bin/prepare-refseqs.pl --fasta files/refseq/Chr3L.fasta && bin/prepare-refseqs.pl --fasta files/refseq/Chr3R.fasta && bin/prepare-refseqs.pl --fasta files/refseq/ChrX.fasta
	## include metadata for this track! (modify data/trackList.json)
	sed -i -e 's/"DNA",/"DNA",\
	"metadata" : {"general_tracks":"Reference Sequence"},/g' data/trackList.json



######################################################################
### 2) FACETED TRACK SELECTOR

## this goes to jbrowse_conf.json

# sed -i -e 's/{/{ \
# "trackSelector":{ \
# "type":"Faceted", \
# "displayColumns":["key","population","country","continent","general_tracks","nucleotide_variation","linkage_disequilibrium","recombination","neutrality_tests","population_differentiation","window_size"], \
# "renameFacets": { "linkage_disequilibrium": "Linkage Disequilibrium", "population_differentitation": "Population Differentiation"}, \
# "selectableFacets":["general_tracks","nucleotide_variation","linkage_disequilibrium","recombination","neutrality_tests","population_differentiation","population","country","continent","window_size"]}/g' jbrowse_conf.json


#######################################################################
### 3) METADATA 

## also goes to jbrowse_conf.json

# sed -i -e 's/"formatVersion":1,/"formatVersion":1, \
# "trackMetadata":{ \
# "indexFacets":["population","country","continent","general_tracks","nucleotide_variation","linkage_disequilibrium","recombination","neutrality_tests","population_differentiation","window_size"], \
# "sources":[{"url":"files\/metadata.csv","type":"csv"}]},/g' data/trackList.json
# #, \ "names":{"type":"Hash","url":"names\/"},/g' data/trackList.json  ### NOT WORKING! generate-names.pl



#####################################################################
### 4) CDS PROPORTION & RECOMBINATION COMERON

sed -i -e 's/"tracks":\[/"tracks":[\
{"key" : "CDS proportion" , \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/cds_perc.bw", \
"label" : "cds_perc", \
"autoscale" : "local", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#FF8C00"}, \
"metadata" : {"general_tracks":"Coding proportion","window_size":"100kb"}}, \
{"key" : "Recombination Comeron", \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/recomb.bw", \
"label" : "recombination", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#993366"}, \
"autoscale" : "local", \
"metadata" : {"recombination":"HR recomb cM/Mb (Comeron et al)","window_size":"100kb"}}, \
{"key" : "RRC 100kb" , \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/RRC_100kb.bw", \
"label" : "RRC_100kb", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#FFC0CB"}, \
"autoscale" : "local", \
"metadata" : {"recombination":"RRC cM/Mb (Fiston-Lavier et al)","window_size":"100kb"}}, \
{"key" : "RRC 50kb" , \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/RRC_50kb.bw", \
"label" : "RRC_50kb", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#FFC0CB"}, \
"autoscale" : "local", \
"metadata" : {"recombination":"RRC cM/Mb (Fiston-Lavier et al)","window_size":"50kb"}}, \
{"key" : "RRC 10kb" , \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/RRC_10kb.bw", \
"label" : "RRC_10kb", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#FFC0CB"}, \
"autoscale" : "local", \
"metadata" : {"recombination":"RRC cM/Mb (Fiston-Lavier et al)","window_size":"10kb"}}, \
{"key" : "RRC 1kb" , \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/RRC_1kb.bw", \
"label" : "RRC_1kb", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#FFC0CB"}, \
"autoscale" : "local", \
"metadata" : {"recombination":"RRC cM/Mb (Fiston-Lavier et al)","window_size":"1kb"}}, \
{"key" : "Gene density 100kb" , \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/genedensity_100kb.bw", \
"label" : "genedensity_100kb", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#FFA500"}, \
"autoscale" : "local", \
"metadata" : {"general_tracks":"Gene density","window_size":"100kb"}}, \
{"key" : "Gene density 10kb" , \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/genedensity_10kb.bw", \
"label" : "genedensity_10kb", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#FFA500"}, \
"autoscale" : "local", \
"metadata" : {"general_tracks":"Gene density","window_size":"10kb"}}, \
{"key" : "Gene density 1kb" , \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/genedensity_1kb.bw", \
"label" : "genedensity_1kb", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#FFA500"}, \
"autoscale" : "local", \
"metadata" : {"general_tracks":"Gene density","window_size":"1kb"}}, \
{"key" : "Gene density 50kb" , \
"type" : "JBrowse\/View\/Track\/Wiggle\/XYPlot", \
"urlTemplate" : "..\/files\/reftracks\/genedensity_50kb.bw", \
"label" : "genedensity_50kb", \
"storeClass" : "JBrowse\/Store\/SeqFeature\/BigWig", \
"style": {"pos_color":"#FFA500"}, \
"autoscale" : "local", \
"metadata" : {"general_tracks":"Gene density","window_size":"50kb"}},/g' data/trackList.json

	## include in trackList.json the information!

#####################################################################
### 5) GENE ANNOTATIONS

bin/flatfile-to-json.pl --trackType CanvasFeatures --trackLabel gene_annotations --autocomplete all --gff files/gff/annotations557.gff3 --key "Gene annotations" --metadata '{"general_tracks":"Gene annotations"}' --config '{"menuTemplate" : [{"label":"View details", "title": "{type} {name}", "action":"contentDialog", "iconClass": "dijitIconTask"},{"iconClass":"dijitIconFilter"},{"label":"Search for {name} at NCBI", "title": "Searching for {name} at NCBI", "iconClass":"dijitIconDatabase","action": "iframeDialog","url":"http://www.ncbi.nlm.nih.gov/gquery/?term={name}"}, {"label":"Search for {name} at FlyBase", "title": "Searching for {name} at FlyBase", "iconClass":"dijitIconFile","action": "iframeDialog","url":"http://flybase.org/reports/{id}.html"},{"iconClass":"dijitIconTable", "action":"iframeDialog", "url":"http://popfly.uab.cat/cgi-bin/R/popflyMKT?geneid={id}", "title":"MKT for {name}", "label" : "MKT for {name}"}]}'
   ## CanvasFeatures with metadata
	#menutemplate: search gene at NCBI!
   #menutemplate: search gene at FlyBase!!!

   ## manually add in tracklist.json: (link flybase and ncbi in view details popup)
   #"fmtDetailValue_Name": "function(name) { return '<a href=\"http://www.ncbi.nlm.nih.gov/gquery/?term='+name+'\" title=\"Search at NCBI\" target=\"_blank\">'+name+'</a>'; }", 
   #"fmtDetailValue_Id": "function(id) { return '<a href=\"http://flybase.org/reports/'+id+'.html\" title=\"Search at FlyBase\" target=\"_blank\">'+id+'</a>'; }", 
        



#####################################################################
### 6) INVERSIONS

bin/flatfile-to-json.pl --gff files/inversions/inversions.gff3 --getLabel --tracklabel inversions --autocomplete all --key "Inversions" --className "feature2" --arrowheadClass "null" --metadata '{"general_tracks":"Inversions"}' --config '{"menuTemplate" : [{"label":"View details","title": "{type} {name}","action":"contentDialog","iconClass": "dijitIconTask"},{"iconClass":"dijitIconFilter"},{"label":"View Frequency distribution among populations","title":"Frequency among populations of {name}","iconClass":"dijitIconDatabase","action": "iframeDialog","url":"files/inversions/{name}.html"}]}'
	# HTMLFeatures with metadata and right-click mouse behaviour!



#####################################################################
### 7) TRANSPOSABLE ELEMENTS

bin/flatfile-to-json.pl --gff files/gff/trans_elements_557.gff3 --getLabel --tracklabel trans_elements --autocomplete all --key "Transposable elements" --className "feature2" --arrowheadClass "null" --metadata '{"general_tracks":"Transposable elements"}' --config '{"menuTemplate" : [{"label":"View details","title": "{type} {name}","action":"contentDialog","iconClass": "dijitIconTask"},{"iconClass":"dijitIconFilter"},{"label":"Search for {name} at NCBI","title": "Searching for {name} at NCBI","iconClass":"dijitIconDatabase","action": "iframeDialog","url":"http://www.ncbi.nlm.nih.gov/gquery/?term={name}"}]}'
	# HTMLFeatures with metadata and right-click mouse behaviour! (search at NCBI)


#####################################################################
### 8) VARISCAN MEASURES!

# files/statistics_wig.sh
	#creates tracks_wig.json and updates metadata.csv
# ------>  manually add tracks_wig.json to data/trackList.json !!!!!!!!!!!!!!!!!!!!!!!!!!!!



####################################################################
### 9) GENERATE NAMES (autocomplete)

bin/generate-names.pl


######################################################################
### 10) ADD TO JBROWSE_CONF.JSON 

{ 
   "plugins": [ 
      "HideTrackLabels",
      "DownloadFasta"
   ],

   "defaultTracks" : "DNA,gene_annotations,inversions,recombination,RRC_100kb",

   "defaultLocation": "2L:1..23011544",
   
   "trackSelector" : {
      "selectableFacets" : [
         "general_tracks",
         "continent",
         "country",
         "population",
         "freq_nucleotide_variation",
         "div_nucleotide_variation",
         "linkage_disequilibrium",
         "recombination",
         "neutrality_tests1",
         "neutrality_tests2",
         "population_differentiation",
         "window_size"
      ],
      "displayColumns" : [
         "key",
         "population",
         "country",
         "continent",
         "general_tracks",
         "nucleotide_variation",
         "linkage_disequilibrium",
         "recombination",
         "neutrality_tests1",
         "neutrality_tests2",
         "population_differentiation",
         "window_size"
      ],
      "type" : "Faceted",
      "renameFacets" : {
         "general_tracks" : "Reference tracks",
         "continent" : "Continent", 
         "country" : "Country", 
         "population" : "Population",
         "freq_nucleotide_variation" : "Frequency-based nucleotide variation",
         "div_nucleotide_variation" : "Divergence-based metrics",
         "linkage_disequilibrium" : "Linkage disequilibrium",
         "recombination" : "Recombination", 
         "neutrality_tests1" : "Selection tests based on SFS and/or variability",
         "neutrality_tests2" : "Selection tests based on polymorphism and divergence",
         "population_differentiation" : "Population differentiation",
         "window_size" : "Visualization (window size)"
      }
   },
   
   "trackMetadata" : {
      "sources" : [
         {
            "url" : "files/metadata.csv",
            "type" : "csv"
         }
      ],
      "indexFacets" : [
         "general_tracks",
         "continent",
         "country",
         "population",
         "freq_nucleotide_variation",
         "div_nucleotide_variation",
         "linkage_disequilibrium",
         "recombination",
         "neutrality_tests1",
         "neutrality_tests2",
         "population_differentiation",
         "window_size"
      ]
   },

   "formatVersion" : 1
}