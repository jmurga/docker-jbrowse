# --------------------------------------#
# JBROWSE: NEW PLUGIN >> DOWNLOAD FASTA #
# --------------------------------------#



JBROWSE CONFIGURATION SETTINGS
	Execute the scrtip: bin/new-plugin.pl
		perl bin/new-plugin.pl DownloadFasta

	Include the script into "jbrowse_conf.json" or "jbrowse.conf"
		"plugins": [ "DownloadFasta" ]
	Or, if we want to use multiple plugins:
		"plugins": [ 
	    	"HideTrackLabels",
	    	"DownloadFasta"
	   	],



JBROWSE MODIFICATIONS
	In order to get an array with all the populations dinamicaly, we'll get the list from the FACETED TRACKLIST.
	Edit src/JBrowse/View/TrackList/Faceted.js >> Give an ID to each category of the tracklist
		// 201612 - DownloadFasta plugin: give an ID to each category
	        // make a selection control for the values of this facet
	        //var facetControl = dojo.create( 'table', {className: 'facetSelect'}, facetPane.containerNode );
	        var facetControl = dojo.create( 'table', {className: 'facetSelect', id: 'facet_select_' + facetName}, facetPane.containerNode );
	    // 201612 - DownloadFasta plugin



FILES 
	Copy/Create these files and directories:
		/files/tmp
		/src/JBrowse/View/BasicDialog.js
		/bin/custom_downloadFASTA_all.pl
		/bin/custom_removeZIP.sh
	Copy all the plugin contents: js, css, images, etc.
		/plugins/DownloadFasta

	Change files owner if necessary and give them the right permissions.
	Made them executable if they aren't!
		chmod -R 755 bin/custom_downloadFASTA_all.pl
		chmod -R 755 bin/custom_removeZIP.sh

	Edit bin/custom_downloadFASTA_all.pl >> Alignments path
	Edit bin/custom_removeZIP.sh >> Temporary ZIP's path

	Change "tmp" folder permissions (for Apache) > Needs 'sudo'
		chown www-data:esanz tmp
		chmod -R 2774 tmp
	Change "tmp" folder permissions (for CentOS) > Needs 'sudo'
		chown -R apache:jbrowse tmp
		chmod -R 2774 tmp

	* In the case of VCF script, it uses local software from /home/jbrowse/bin.
	Be sure that all the directories are executable (home, jbrowse, bin, htslib),
	so the Apache user can access them.

SERVER > Need 'sudo'
	Change the server configuration: /etc/apache2/sites-available/default.conf
	If there's a general Perl scripts rule, put it in the specific application that needs it
		<Directory /var/www/html/invdb-dev>
		    Options -Indexes
			<Files ~ "\.(pl|cgi)$">
			        SetHandler perl-script
			        PerlResponseHandler ModPerl::PerlRun
			        Options +ExecCGI
			        PerlSendHeader On
			</Files>
		</Directory>
	
	Give the proper instructions to handle Perl scripts as wanted
		<Directory /var/www/html/popfly/bin>
			# Match the custom files in the bin folder. Deal them as Perl executable scripts
			# ModPerl::PerlRun doesn't allow chdir()
			<Files ~ "^custom_.+\.(pl|cgi)$">
				Options +ExecCGI
		        AddHandler cgi-script .cgi .pl
		    </Files>
		</Directory>

	Reset the service: Apache (sudo)
		apache2ctl restart
	Reset the service: CentOS (sudo)
		systemctl restart httpd

	Increase the maximum execution time (in seconds) of the server!
		(CentOS): /etc/httpd/conf/httpd.conf 	|	(Apache): /etc/apache2/apache2.conf
			Timeout 1500


EXECUTE "custom_removeZIP.sh" AUTOMATICALLY
	Generate a "crontab" for the "www-data" user ("apache" user in CentOS)
		sudo crontab -u www-data -e
	Select the preferred editor: Nano = 2
	Execute the script every 4 minutes (copy only the first line)
		*/4 * * * * /var/www/html/popfly/bin/custom_removeZIP.sh
	   #|   | | | |
	   #|   | | | |
	   #|   | | | +----- day of week  (0 - 6, Sunday=0)
	   #|   | | +------- month        (1 - 12)
	   #|   | +--------- day of month (1 - 31)
	   #|   +----------- hour         (0 - 23)
	   #+--------------- min          (0 - 59)
	Exit and save: Ctrl+X >> Yes
	Check it was added properly: list all the "tasks"
		crontab -u www-data -l



OTHER: POSSIBLE CONFIGURATIONS NEEDED TO EXECUTE THE PLUGIN'S SCRIPTS PROPERLY

	Install corresponding CGI package for Perl
		#perl -MCPAN -e shell
		cpan
		#install Module::CGI::Install
		install CGI::Fast

	Install corresponding AJAX package for Perl
		cpan
		install CGI::Ajax
		install G/GO/GOZER/mod_perl-2.0.4.tar.gz
		# "apxs" was required, so we intalled apache2-dev from a new terminal. After, continue with mod_perl installation
		sudo apt-get install apache2-dev
