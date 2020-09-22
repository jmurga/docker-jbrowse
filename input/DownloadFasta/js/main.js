/*
DownloadFasta JBrowse plugin
*/
/*
	Created on : Nov 9, 2016, 15:12:28 PM
	Author     : ESanz
*/

define([
	'dojo/_base/declare',
	'dojo/_base/lang',
	'dojo/Deferred',
	'dojo/dom-construct',
	'dijit/form/Button',
	'dijit/form/RadioButton',
	'dijit/MenuItem',
	'dojo/fx',
	'dojo/dom',
	'dojo/dom-style',
	'dojo/on',
	'dojo/query',
	'dojo/dom-geometry',
	'JBrowse/Plugin',
	'JBrowse/Model/Location',
	'JBrowse/View/BasicDialog'
	//'JBrowse/View/Dialog/WithActionBar',
	//'JBrowse/View/InfoDialog',
	//'dijit/Dialog'
	],
	function(
		declare,
		lang,
		Deferred,
		domConstruct,
		dijitButton,
		dijitRadioButton,
		dijitMenuItem,
		coreFx,
		dom,
		style,
		on,
		query,
		domGeom,
		JBrowsePlugin,
		Location,
		BasicDialog
		//ActionBarDialog,
		//InfoDialog,
		//Dialog
	) {
		return declare( JBrowsePlugin,
		{
			constructor: function( args )
				{
					//console.log("plugin DownloadFastaButton constructor");

					var baseUrl = this._defaultConfig().baseUrl;
					var thisB = this;

					this.browser.afterMilestone( 'initView', function() {

						var navBox = dojo.byId("navbox");

						// Define the content of the dialog
						var DFDialog = thisB._DFDialogContent();

						// Create the DownloadFASTA button
						thisB.browser.fastaButton = new dijitButton(
						{
							title: "Download sequences",
							id: "fasta-btn",
							width: "24px",
							onClick: function(){
								thisB._updateDialog();
								DFDialog.show();
							}
						},dojo.create('button',{},navBox));

						// Enable the menu option (disabled by default)
						dijit.byId("menubar_download_fasta").setDisabled(false);

					});
				},

			_getLoc: function()
				{
					// Get default location from URL or from the locationBox
					//var initLocation = this.browser.locationBox.get('value');     // Get the location through the locationBox
					var initLocation = window.location.href;            // Get URL (to get the location)
					var loc = initLocation.match(/loc=([^&]*)/).pop();  // Get Chr+Location
					var chr = loc.match(/chr(\d*)%3A/).pop();           // Get Chromosome
					var start = loc.match(/.*%3A(\d+[^\.\.]*)/).pop();  // Get START
					var end = loc.match(/\.\.(\d+[^&]*)/).pop();        // Get END

					return [start, end, chr];
				},

			_updateDialog: function()
				{
					// Update location
					var loc = this._getLoc();
					document.getElementById("inputStart").value = loc[0];
					document.getElementById("inputEnd").value = loc[1];
					document.getElementById("inputChr").value = loc[2];

					// Restart AJAX response
					//document.getElementById("resultDiv").innerHTML = '';
					if (    /.*spinner.*/.test(document.getElementById("resultDiv").innerHTML)
						&&  !(dijit.byId("downloadButton").get('disabled'))     )
					{ document.getElementById("resultDiv").innerHTML = ''; }
				},

			_DFDialogContent: function()
				{
					var thisB = this;

					// Determines when to show/hide the population check-list
					var fastaChkList_expanded = false;

					// Create a DIV for all the dialog's content
					var DFDialogContent = dojo.create("div", { class: 'DFDialogContent' });
					
					//<div class="searchbody" style="background:#FFFFD5;padding:10px;width:95%;text-align:center;">

					var init_innerHTML = ''
						+ '<form id="DF_form" method="post" enctype="application/x-www-form-urlencoded" target="_blank" action="">'
						+ '<table class="classTable_form">'
							+ '<tr>'
								+ '<td class="classTd_right">'
									+ '<span>Info: </span>'
								+ '</td>'
								+ '<td class="classTd_left">'
								+ '<span class="classSpan_tt_link">'
									+ '<img src="plugins/DownloadFasta/img/infoIcon.png">'
									//+ '<div id="infoIcon"></div>'
									+ '<span class="classSpan_tt_note">'
										+ 'This process may take a few minutes. However, you can close this dialog and keep navigating across PopHuman.'
									+ '</span>'
								+ '</span>'
								+ '</td>'
							+ '</tr>';

					// Create the HTML code for the chromosome list
					var chrList_innerHTML = thisB._fillChrList();

					// Get the current location
					var loc = thisB._getLoc();

					// Create the HTML code for the location fields
					var location_innerHTML = ''
							+ '<tr>'
								+ '<td class="classTd_right">'
									+ '<span>Start coordinate: </span>'
								+ '</td>'
								+ '<td class="classTd_left">'
									+ '<input id="inputStart" type="text" value="' + loc[0] + '">'
								+ '</td>'
							+ '</tr><tr>'
								+ '<td class="classTd_right">'
									+ '<span>End coordinate: </span>'
								+ '</td>'
								+ '<td class="classTd_left">'
									+ '<input id="inputEnd" type="text" value="' + loc[1] + '">'
								+ '</td>'
							+ '</tr>';

					// Create the HTML code for the populations check-list
					var chkList_innerHTML = thisB._fillChkList();

					// Create radiobuttons to chose the output in a single file or in multiple files
					var output_innerHTML = ''
							+ '<tr>'
								+ '<td class="classTd_rightTop">'
									+ '<span>Output: </span>'
								+ '</td>'
								+ '<td class="classTd_left">'
									+ '<input id="inputSeparate" type="radio" name="output" value="separate" checked title="One alignment file for each selected population">'
									+ '<span title="One alignment file for each selected population">&nbsp;Each population in a separate file</span><br>'
									+ '<input id="inputSingle" type="radio" name="output" value="single" title="One single alignment file for all selected populations">'
									+ '<span title="A single alignment file for all selected populations">&nbsp;One file with all populations</span><br>'
								+ '</td>'
							+ '</tr>';

					// Create a checkbox to include Reference Sequence
					var refSeq_innerHTML = ''
							+ '<tr title="Include the Reference Sequence (v.5.57) in the output alignment">'
								+ '<td class="classTd_right">'
									+ '<span>Include ref. seq.: </span>'
								+ '</td>'
								+ '<td class="classTd_left">'
									+ '<input id="inputRefSeq" type="checkbox" value="RefSeq" unchecked/>'
								+ '</td>'
							+ '</tr>';

					// Format
					var format_innerHTML = ''
							+ '<tr>'
								+ '<td class="classTd_rightTop">'
									+ '<span>Format: </span>'
								+ '</td>'
								+ '<td class="classTd_left">'
									+ '<input id="inputVcf" type="radio" name="format" value="vcf" checked>'
									+ '<span>&nbsp;VCF</span><br>'
								+ '</td>'
							+ '</tr>';
					
					// Append all the HTML blocks
					DFDialogContent.innerHTML = ''
						+ init_innerHTML
							+ chrList_innerHTML
							+ location_innerHTML
							+ chkList_innerHTML
							+ output_innerHTML
							+ refSeq_innerHTML
							+ format_innerHTML
						+ '</table>'
					+ '</form>'
					+ '<div class="resultDiv" id="resultDiv"></div>';

					// Buttons
					var actionBar = dojo.create( 'div', { className: 'infoDialogActionBar dijitDialogPaneActionBar' });
					var downButton = new dijitButton({
						id: 'downloadButton',
						className: 'Download',
						label: 'Download',
						onClick: dojo.hitch(this,'downloadFile')
					}).placeAt(actionBar);
					/*var CancelButton = new dijitButton({
						className: 'Cancel',
						label: 'Cancel',
						onClick: dojo.hitch(this,'hidePlugin')
					}).placeAt(actionBar);*/
					//.placeAt(actionBar) >> is equivalent to >> actionBar.appendChild(CancelButton.domNode);

					// Append the buttons block
					DFDialogContent.appendChild(actionBar);


					// Create the dialog
					var myBasicDialog = new BasicDialog(
						{
							title: 'Download sequences',
							content: DFDialogContent,
							className: 'basic-dialog'
						});

					
					// HANDLE EVENTS

					// On change format, modify the reference-sequence checkbox
					var iVcf = document.getElementById("inputVcf");
					var iRefSeq = document.getElementById("inputRefSeq");
					if (iVcf.checked == true) {
				iRefSeq.checked = true;
				iRefSeq.disabled = true;
				}
					/*if (iVcf && iRefSeq) {
						iVcf.addEventListener("click", function(){
							iRefSeq.checked = true;
							iRefSeq.disabled = true;
						});
					}*/

					// Expand/Hide the populations check-list when clicking the form
					document.getElementById("selectBoxId").addEventListener("click", function(){
						var checkboxes_div = document.getElementById("popChkBoxes");
						if (!fastaChkList_expanded) {
							checkboxes_div.style.display = "block";
							fastaChkList_expanded = true;
						} else {
							checkboxes_div.style.display = "none";
							fastaChkList_expanded = false;
						}
					});

					// Select/Unselect all checkboxes from a check-list menu
					var checkboxes = document.getElementsByName("DF_chk");
					document.getElementById("selectAllId").addEventListener("click", function(){
						for(var i=0, n=checkboxes.length; i<n; i++) {
							checkboxes[i].checked = document.getElementById("selectAllId").checked;
						}
					});

					// Return the dialog
					return myBasicDialog;

				},

			// Fill the dropdown menu (check-list) with the given list values
			_fillChrList: function()
				{
					/*// Select all chromosomas and list them in an array.
					var chrTable = [];
					var chrList = [];*/
					
					/*// ALTERNATIVE 1: GET CHROMOSOMES
					// The table with the chromosomas is inside a DIV with id="dijit_form_Select_0_menu"
						//var chrTable = document.getElementById("dijit_form_Select_0_menu").innerHTML.getElementsByTagName("TABLE");
						var chrTable = document.getElementById("dijit_form_Select_0_menu").getElementsByTagName("TABLE");
					// Get the chromosomes within the table
						for (i = 0; i < chrTable.rows.length; i++) { 
							chrList.push(chrTable.rows[i].cells[1].innerHTML);
						}*/

					/*// ALTERNATIVE 2: GET CHROMOSOMES
						var refSeqsPath = '../../' + this.browser.config.refSeqs.url;
					// Read the refSeqs file in a string (to complete)
						var str = {};
					// Get the chromosomes (all these regular expressions get the same result):
						var chrList = str.match(/\"name\":\"(.*?)\"/g);
						//var refSeqs = str.match(/\"name\":\"([^\"]*)/g);
						//var refSeqs = str.match(/\"name\":\"([^\"]+)\"/g);*/


					// Define the form
					var chrList_innerHTML = {};
					chrList_innerHTML = ''
						+ '<tr>'
							+ '<td class="classTd_right">'
								+ '<span>Chromosome: </span>'
							+ '</td>'
							+ '<td class="classTd_left"><select id="inputChr">';
					
					// If the chromosomes are taken dinamically (ALTERNATIVE 1 OR 2):
					/*if(chrList.length == 0) {
						chrList_innerHTML     += '<span>Not found</span>';
					} else {
						// List the values
						chrList.forEach(function(item, index) {
							chrList_innerHTML += '<option value="' + item + '">' + item + '</option>';
						});
					}*/

					// If the chromosomes are taken manually:
					chrList_innerHTML += '<option value="1">1</option>'
						+ '<option value="2">2</option>'
						+ '<option value="3">3</option>'
						+ '<option value="4">4</option>'
						+ '<option value="5">5</option>'
						+ '<option value="6">6</option>'
						+ '<option value="7">7</option>'
						+ '<option value="8">8</option>'
						+ '<option value="9">9</option>'
						+ '<option value="10">10</option>'
						+ '<option value="11">11</option>'
						+ '<option value="12">12</option>'
						+ '<option value="13">13</option>'
						+ '<option value="14">14</option>'
						+ '<option value="15">15</option>'
						+ '<option value="16">16</option>'
						+ '<option value="17">17</option>'
						+ '<option value="18">18</option>'
						+ '<option value="19">19</option>'
						+ '<option value="20">20</option>'
						+ '<option value="21">21</option>'
						+ '<option value="22">22</option>'
						+ '<option value="X">X</option>'
						+ '<option value="Y">Y</option>'

					chrList_innerHTML += ''
							+ '</select></td>'
						+ '</tr>';

					return chrList_innerHTML;
				},


			// Fill the dropdown menu (check-list) with the given list values
			_fillChkList: function()
				{
					// Select all populations and list them in an array
					var popTable = document.getElementById("facet_select_population");
					var popList = [];
					for (i = 0; i < popTable.rows.length; i++) { 
						var popName = popTable.rows[i].cells[1].innerHTML;
						// Ignore those populations which are actually not populations, but a relation between 2 populations.
						// We identify them because they have a comma in the name: CEU,YRI / CHB,CEU / CHB,YRI
						if (popName.indexOf(',') === -1) {
							// Add the population in an array
							popList.push(popName);
						}
					}

					// Define the form
					var chkList = {};
					chkList = ''
						+ '<tr>'
							+ '<td class="classTd_rightTop">'
								+ '<span>Populations: </span>'
							+ '</td>'
							+ '<td class="classTd_left">'
								+ '<div class="multiselect">'
									+ '<div class="selectBox" id="selectBoxId">'
										+ '<select><option>Select</option></select>'
										+ '<div class="overSelect"></div>'
									+ '</div>'
									+ '<div id="popChkBoxes">';

					if(popList.length == 0) {
						chkList     += '<span>Populations table not found</span>';
					} else {
						// List the values
						chkList     += '<label><input type="checkbox" id="selectAllId"/> SELECT ALL <br></label>';
						popList.forEach(function(item, index) {
							if(item != "(no data)") {
								chkList += '<label><input type="checkbox" name="DF_chk" value="' + item + '"/> ' + item + '<br></label>';
							}
						});
					}

					// Close HMTL tags
					chkList         += '</div>'
								+ '</div>'
							+ '</td>'
						+ '</tr>';

					return chkList;
				},

			downloadFile: function()
				{
					// Script that processes the data
					if(document.getElementById("inputVcf").checked) {
						var url = 'bin/downloadVcf.pl';
					}

					// Get an array of all the checked populations
					var chkPops = document.getElementsByName("DF_chk");
					var chkPopsValues = [];
					
					// Codify the array to URL
					var keyName = "chkPopsValues";
					for (var i = 0; i < chkPops.length; i++) {
						if (chkPops[i].value != "SELECT ALL" && chkPops[i].checked) {
							chkPopsValues.push(encodeURIComponent(keyName) + '=' + encodeURIComponent(chkPops[i].value));
						}
					}
					var queryString = chkPopsValues.join("&");

					// Check which output format was selected
					var outputForm = "separate";
					if(document.getElementById("inputSingle").checked) { outputForm = "single"; }

					// Codify all the form values to URL
					var sendStr = "chr=chr" + document.getElementById("inputChr").value
								+ "&start=" + document.getElementById("inputStart").value
								+ "&end=" + document.getElementById("inputEnd").value
								+ "&ref=" + document.getElementById("inputRefSeq").checked
								+ "&output=" + outputForm
								+ "&" + queryString;


					// Connect with the server via AJAX and process the data
					if (window.XMLHttpRequest) {                                // code for IE7+, Firefox, Chrome, Opera, Safari
						var xmlhttp = new XMLHttpRequest();
					} else if(window.ActiveXObject) {
						var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");   // code for IE6, IE5
					} else {
						alert("Your browser doesn't provide XMLHttprequest functionality");
						return;
					}

					if (xmlhttp) {
						xmlhttp.onreadystatechange = function() {

							if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
								
								if (/.+\.zip$/.test(xmlhttp.responseText)) {    // check if the script returns ZIP file
									window.location = xmlhttp.responseText;     //window.open(xmlhttp.responseText);
									dijit.byId("downloadButton").set('disabled', false);
									document.getElementById("resultDiv").innerHTML = '';
								} else if (/^Err:.+/.test(xmlhttp.responseText)) {
									dijit.byId("downloadButton").set('disabled', false);
									document.getElementById("resultDiv").innerHTML = ''
										+ '<span class="class_error"><br>' + xmlhttp.responseText + '</span>';
								} else {
									dijit.byId("downloadButton").set('disabled', false);
									document.getElementById("resultDiv").innerHTML = ''
										+ '<span class="class_error"><br>Something went wrong...</span>';
										//+ '<span class="class_error"><br>Something went wrong... ' + xmlhttp.responseText + '</span>';
								}
								
							} else {
								if (/^Err:.+/.test(xmlhttp.responseText)) {
									dijit.byId("downloadButton").set('disabled', false);
									document.getElementById("resultDiv").innerHTML = ''
										+ '<span class="class_error"><br>' + xmlhttp.responseText + '\n</span>';
								} else {
									dijit.byId("downloadButton").set('disabled', true);
									document.getElementById("resultDiv").innerHTML = ''
										+ '<br>&nbsp;&nbsp;<img src="img/spinner.gif">';
								}
							}

						};
						xmlhttp.open("POST", url, true);
						xmlhttp.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
						xmlhttp.send(sendStr);
					}

				}

			/*hidePlugin: function()
				{
					this.inherited( arguments );
					array.forEach( this._extraEvents, function( e ) {
									e.remove();
								});
				}
			*/

		});
});
