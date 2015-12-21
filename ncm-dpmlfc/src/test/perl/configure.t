#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 18;
use Test::NoWarnings;
use Test::Quattor qw(dpm-config);
use NCM::Component::dpmlfc;
use Readonly;
use CAF::Object;
Test::NoWarnings::clear_warnings();

=pod

=head1 SYNOPSIS

This is a test suite for ncm-dpmlfc (full cconfiguration).

=cut

Readonly my $DPMLFC_CONFIG_PATH => '/software/components/dpmlfc';

Readonly my $DPM_HEAD_HOST => 'grid05.lal.in2p3.fr';
Readonly my $DPM_DISK_HOST => 'grid16.lal.in2p3.fr';

Readonly my $DPM_INITD_SCRIPT => '/etc/init.d/dpm-all-daemons';
Readonly my $DPM_SYSCONFIG_FILE => '/etc/sysconfig/dpm';
Readonly my $DPNS_SYSCONFIG_FILE => '/etc/sysconfig/dpnsdaemon';
Readonly my $RFIO_SYSCONFIG_FILE => '/etc/sysconfig/rfiod';
Readonly my $SRMV1_SYSCONFIG_FILE => '/etc/sysconfig/srmv1';
Readonly my $SRMV2_SYSCONFIG_FILE => '/etc/sysconfig/srmv2';
Readonly my $SRMV22_SYSCONFIG_FILE => '/etc/sysconfig/srmv2.2';
Readonly my $DMLITE_CONFIG_FILE => '/etc/httpd/conf.d/zlcgdm-dav.conf';


Readonly my $DPM_INITD_EXPECTED => '#!/bin/sh

/etc/init.d/dpm $*
/etc/init.d/dpmcopyd $*
/etc/init.d/dpnsdaemon $*
/etc/init.d/httpd $*
/etc/init.d/rfiod $*
/etc/init.d/srmv1 $*
/etc/init.d/srmv2.2 $*
';


Readonly my $DPM_INITIAL_CONFIG =>'#
# $Id: dpm.sysconfig.mysql 9758 2013-11-28 16:54:06Z dhsmith $
#
# @(#)$RCSfile: dpm.sysconfig.mysql,v $ $Revision: 9758 $ $Date: 2013-11-28 17:54:06 +0100 (Thu, 28 Nov 2013) $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the dpm daemon run?
# any string but "yes" will equivalent to "NO"
#
RUN_DPMDAEMON="yes"
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

ALLOW_COREDUMP="no" 		# Line generated by Quattor

#################
# DPM variables #
#################

# - DPM Name Server host : please change !!!!!!
#DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - Number of DPM fast threads :
#NB_FTHREADS=70 		# Line generated by Quattor

# - Number of DPM slow threads :
#NB_STHREADS=20 		# Line generated by Quattor

# - DPM log file :
#DPMDAEMONLOGFILE="/var/log/dpm/log"

# - DPM configuration file :
DPMCONFIGFILE=/etc/DPMCONFIG		# Line generated by Quattor

# - Use DPM synchronous get
#export DPM_USE_SYNCGET="yes"

###################
# Globus variable #
###################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

# - make sure we use globus pthread model
#export GLOBUS_THREAD_MODEL=pthread 		# Line generated by Quattor
#DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export DPNS_HOST=<host name>
export DPM_HOST=<host name>
';

Readonly my $DPM_EXPECTED_CONFIG =>'# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# $Id: dpm.sysconfig.mysql 9758 2013-11-28 16:54:06Z dhsmith $
#
# @(#)$RCSfile: dpm.sysconfig.mysql,v $ $Revision: 9758 $ $Date: 2013-11-28 17:54:06 +0100 (Thu, 28 Nov 2013) $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the dpm daemon run?
# any string but "yes" will equivalent to "NO"
#
RUN_DPMDAEMON="yes"
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

ALLOW_COREDUMP="yes"		# Line generated by Quattor

#################
# DPM variables #
#################

# - DPM Name Server host : please change !!!!!!
#DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - Number of DPM fast threads :
NB_FTHREADS=70		# Line generated by Quattor

# - Number of DPM slow threads :
NB_STHREADS=20		# Line generated by Quattor

# - DPM log file :
#DPMDAEMONLOGFILE="/var/log/dpm/log"

# - DPM configuration file :
DPMCONFIGFILE=/etc/DPMCONFIG		# Line generated by Quattor

# - Use DPM synchronous get
#export DPM_USE_SYNCGET="yes"

###################
# Globus variable #
###################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

# - make sure we use globus pthread model
export GLOBUS_THREAD_MODEL=pthread		# Line generated by Quattor
#DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
';


Readonly my $DPNS_INITIAL_CONFIG => '#
# $Id: dpnsdaemon.sysconfig.mysql,v 1.13 2007/07/26 12:09:10 slemaitr Exp $
#
# @(#)$RCSfile: dpnsdaemon.sysconfig.mysql,v $ $Revision: 1.13 $ $Date: 2007/07/26 12:09:10 $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the DPNS daemon run?
# any string but "yes" will be equivalent to "no"
#
#RUN_DPNSDAEMON="yes"
#
# should the DPNS be read-only ?
# any string but "yes" will be equivalent to "no"
#
RUN_READONLY="no"
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

#ALLOW_COREDUMP="yes"

##################
# DPNS variables #
##################

# - Number of DPNS threads :
#NB_THREADS=20

# - DPNS log file :
#DPNSDAEMONLOGFILE="/var/log/dpns/log"

# - DPNS configuration file :
NSCONFIGFILE=<file name>

# - Initialization of the Catalogue Sync embedded message producer
# - Comment out to disable the message sending
export SEMSGCONFIGFILE=/opt/lcg/etc/SEMsgConfig_dpmhead.cf.tmpl

########################
# Globus configuration #
########################

# - make sure we use globus pthread model
export GLOBUS_THREAD_MODEL=pthread 		# Line generated by Quattor
';

Readonly my $DPNS_EXPECTED_CONFIG => '# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# $Id: dpnsdaemon.sysconfig.mysql,v 1.13 2007/07/26 12:09:10 slemaitr Exp $
#
# @(#)$RCSfile: dpnsdaemon.sysconfig.mysql,v $ $Revision: 1.13 $ $Date: 2007/07/26 12:09:10 $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the DPNS daemon run?
# any string but "yes" will be equivalent to "no"
#
RUN_DPNSDAEMON="yes"		# Line generated by Quattor
#
# should the DPNS be read-only ?
# any string but "yes" will be equivalent to "no"
#
RUN_READONLY="no"
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

#ALLOW_COREDUMP="yes"

##################
# DPNS variables #
##################

# - Number of DPNS threads :
#NB_THREADS=20

# - DPNS log file :
#DPNSDAEMONLOGFILE="/var/log/dpns/log"

# - DPNS configuration file :
NSCONFIGFILE=/etc/DPMCONFIG		# Line generated by Quattor

# - Initialization of the Catalogue Sync embedded message producer
# - Comment out to disable the message sending
export SEMSGCONFIGFILE=/opt/lcg/etc/SEMsgConfig_dpmhead.cf.tmpl

########################
# Globus configuration #
########################

# - make sure we use globus pthread model
export GLOBUS_THREAD_MODEL=pthread		# Line generated by Quattor
export DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
';


Readonly my $RFIO_INITIAL_CONFIG => '#
# $Id: rfiod.sysconfig,v 1.9 2009/03/17 09:36:49 dhsmith Exp $
#
# @(#)$RCSfile: rfiod.sysconfig,v $ $Revision: 1.9 $ $Date: 2009/03/17 09:36:49 $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should rfiod run?
# any string but "yes" will equivalent to "NO"
#
#RUN_RFIOD="no"
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

######################
# DPM RFIO variables #
######################

# - DPM Name Server host : please change !!!!!!
DPNS_HOST=grid05.lal.in2p3.fr

# - DPM host : please change !!!!!!
DPM_HOST=grid05.lal.in2p3.fr

# - RFIO log file :
#RFIOLOGFILE=/var/log/rfio/log

###################
# RFIO Port Range #
###################

# - RFIO port range :
#RFIO_PORT_RANGE="20000 25000"

###################
# Globus variable #
###################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

#########################
# RFIOD Startup Options #
#########################

#OPTIONS="-sl"
export DPNS_HOST=<host name>
';

Readonly my $RFIO_EXPECTED_CONFIG => '# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# $Id: rfiod.sysconfig,v 1.9 2009/03/17 09:36:49 dhsmith Exp $
#
# @(#)$RCSfile: rfiod.sysconfig,v $ $Revision: 1.9 $ $Date: 2009/03/17 09:36:49 $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should rfiod run?
# any string but "yes" will equivalent to "NO"
#
RUN_RFIOD="yes"		# Line generated by Quattor
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

######################
# DPM RFIO variables #
######################

# - DPM Name Server host : please change !!!!!!
#DPNS_HOST=grid05.lal.in2p3.fr

# - DPM host : please change !!!!!!
#DPM_HOST=grid05.lal.in2p3.fr

# - RFIO log file :
#RFIOLOGFILE=/var/log/rfio/log

###################
# RFIO Port Range #
###################

# - RFIO port range :
#RFIO_PORT_RANGE="20000 25000"

###################
# Globus variable #
###################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

#########################
# RFIOD Startup Options #
#########################

#OPTIONS="-sl"
export DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
';


Readonly my $SRMV1_INITIAL_CONFIG => '# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# $Id: srmv1.sysconfig.mysql,v 1.13 2009/01/25 23:30:56 szamsu Exp $
#
# @(#)$RCSfile: srmv1.sysconfig.mysql,v $ $Revision: 1.13 $ $Date: 2009/01/25 23:30:56 $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the srmv1 daemon run?
# any string but "yes" will equivalent to "NO"
#
RUN_SRMV1DAEMON="yes"		# Line generated by Quattor
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

#ALLOW_COREDUMP="yes"

#######################
# DPM SRMv1 variables #
#######################

# - DPM host : please change !!!!!!
#DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - DPM Name Server host : please change !!!!!!
#DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - SRMv1 log file :
#SRMV1DAEMONLOGFILE="/var/log/srmv1/log"

# - DPM configuration file :
DPMCONFIGFILE=/etc/DPMCONFIG		# Line generated by Quattor

####################
# Globus variables #
####################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

# - grid-mapfile location
#GRIDMAP=/etc/grid-security/grid-mapfile
export DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export GLOBUS_THREAD_MODEL=pthread		# Line generated by Quattor
';

Readonly my $SRMV1_EXPECTED_CONFIG => '# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# $Id: srmv1.sysconfig.mysql,v 1.13 2009/01/25 23:30:56 szamsu Exp $
#
# @(#)$RCSfile: srmv1.sysconfig.mysql,v $ $Revision: 1.13 $ $Date: 2009/01/25 23:30:56 $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the srmv1 daemon run?
# any string but "yes" will equivalent to "NO"
#
RUN_SRMV1DAEMON="yes"		# Line generated by Quattor
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

#ALLOW_COREDUMP="yes"

#######################
# DPM SRMv1 variables #
#######################

# - DPM host : please change !!!!!!
#DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - DPM Name Server host : please change !!!!!!
#DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - SRMv1 log file :
#SRMV1DAEMONLOGFILE="/var/log/srmv1/log"

# - DPM configuration file :
DPMCONFIGFILE=/etc/DPMCONFIG		# Line generated by Quattor

####################
# Globus variables #
####################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

# - grid-mapfile location
#GRIDMAP=/etc/grid-security/grid-mapfile
export DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export GLOBUS_THREAD_MODEL=pthread		# Line generated by Quattor
';


Readonly my $SRMV2_INITIAL_CONFIG => '# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# $Id: srmv2.sysconfig.mysql,v 1.12 2009/03/30 14:53:11 dhsmith Exp $
#
# @(#)$RCSfile: srmv2.sysconfig.mysql,v $ $Revision: 1.12 $ $Date: 2009/03/30 14:53:11 $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the srmv2 daemon run?
# any string but "yes" will equivalent to "NO"
#
RUN_SRMV2DAEMON="no"		# Line generated by Quattor
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

#ALLOW_COREDUMP="yes"

#######################
# DPM SRMv2 variables #
#######################

# - DPM host : please change !!!!!!
DPM_HOST=<DPM_hostname>

# - DPM Name Server host : please change !!!!!!
DPNS_HOST=<DPNS_hostname>

# - SRMv2 log file :
#SRMV2DAEMONLOGFILE="/var/log/srmv2/log"

# - DPM configuration file :
#DPMCONFIGFILE="/etc/DPMCONFIG"

####################
# Globus variables #
####################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

# - grid-mapfile location
#GRIDMAP=/etc/grid-security/grid-mapfile
';

Readonly my $SRMV2_EXPECTED_CONFIG => '# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# $Id: srmv2.sysconfig.mysql,v 1.12 2009/03/30 14:53:11 dhsmith Exp $
#
# @(#)$RCSfile: srmv2.sysconfig.mysql,v $ $Revision: 1.12 $ $Date: 2009/03/30 14:53:11 $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the srmv2 daemon run?
# any string but "yes" will equivalent to "NO"
#
RUN_SRMV2DAEMON="no"		# Line generated by Quattor
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

#ALLOW_COREDUMP="yes"

#######################
# DPM SRMv2 variables #
#######################

# - DPM host : please change !!!!!!
DPM_HOST=<DPM_hostname>

# - DPM Name Server host : please change !!!!!!
DPNS_HOST=<DPNS_hostname>

# - SRMv2 log file :
#SRMV2DAEMONLOGFILE="/var/log/srmv2/log"

# - DPM configuration file :
#DPMCONFIGFILE="/etc/DPMCONFIG"

####################
# Globus variables #
####################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

# - grid-mapfile location
#GRIDMAP=/etc/grid-security/grid-mapfile
';


Readonly my $SRMV22_INITIAL_CONFIG => '# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# $Id: srmv2.2.sysconfig.mysql 9306 2013-08-15 06:51:53Z dhsmith $
#
# @(#)$RCSfile: srmv2.2.sysconfig.mysql,v $ $Revision: 9306 $ $Date: 2013-08-15 08:51:53 +0200 (Thu, 15 Aug 2013) $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the srmv2.2 daemon run?
# any string but "yes" will equivalent to "NO"
#
RUN_SRMV2DAEMON="yes"
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

#ALLOW_COREDUMP="yes"

#######################
# DPM SRMv2.2 variables #
#######################

# - DPM host : please change !!!!!!
#DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - DPM Name Server host : please change !!!!!!
#DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - Number of SRM threads :
#NB_THREADS=20

# - SRMv2 log file :
#SRMV2DAEMONLOGFILE="/var/log/srmv2.2/log"

# - DPM configuration file :
DPMCONFIGFILE=/etc/DPMCONFIG		# Line generated by Quattor

####################
# Globus variables #
####################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

# - grid-mapfile location
#GRIDMAP=/etc/grid-security/grid-mapfile

# - make sure we use globus pthread model
export GLOBUS_THREAD_MODEL=pthread 		# Line generated by Quattor
export DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
';

Readonly my $SRMV22_EXPECTED_CONFIG => '# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# $Id: srmv2.2.sysconfig.mysql 9306 2013-08-15 06:51:53Z dhsmith $
#
# @(#)$RCSfile: srmv2.2.sysconfig.mysql,v $ $Revision: 9306 $ $Date: 2013-08-15 08:51:53 +0200 (Thu, 15 Aug 2013) $ CERN/IT/ADC/CA Jean-Damien Durand
#
# should the srmv2.2 daemon run?
# any string but "yes" will equivalent to "NO"
#
RUN_SRMV2DAEMON="yes"
#
# should we run with another limit on the number of file descriptors than the default?
# any string will be passed to ulimit -n
#ULIMIT_N=4096
#
###############################################################################################
# Change and uncomment the variables below if your setup is different than the one by default #
###############################################################################################

#ALLOW_COREDUMP="yes"

#######################
# DPM SRMv2.2 variables #
#######################

# - DPM host : please change !!!!!!
#DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - DPM Name Server host : please change !!!!!!
#DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor

# - Number of SRM threads :
#NB_THREADS=20

# - SRMv2 log file :
#SRMV2DAEMONLOGFILE="/var/log/srmv2.2/log"

# - DPM configuration file :
DPMCONFIGFILE=/etc/DPMCONFIG		# Line generated by Quattor

####################
# Globus variables #
####################

# - gridmapdir location
#GRIDMAPDIR=/etc/grid-security/gridmapdir

# - grid-mapfile location
#GRIDMAP=/etc/grid-security/grid-mapfile

# - make sure we use globus pthread model
export GLOBUS_THREAD_MODEL=pthread		# Line generated by Quattor
export DPNS_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
export DPM_HOST=grid05.lal.in2p3.fr		# Line generated by Quattor
';


# DPM 1.8.10 default config provided by the RPM
Readonly my $DMLITE_INITIAL_CONFIG => '#
# This is the Apache configuration for the dmlite DAV.
#
# The first part of the file configures all the required options common to all
# VirtualHosts. The actual VirtualHost instances are defined at the end of this file.
#

# Static content
Alias /static/ /usr/share/lcgdm-dav/
<Location "/static">
  <IfModule expires_module>
    ExpiresActive On
    ExpiresDefault "access plus 1 month"
  </IfModule>
  <IfModule include_module>
    Options +Includes
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
  </IfModule>
</Location>

# Custom error messages
# Only make sense if include_module is loaded
<IfModule include_module>
    ErrorDocument   400 /static/errors/400.shtml
    ErrorDocument   403 /static/errors/403.shtml
    ErrorDocument   404 /static/errors/404.shtml
    ErrorDocument   405 /static/errors/405.shtml
    ErrorDocument   409 /static/errors/409.shtml
    ErrorDocument   500 /static/errors/500.shtml
    ErrorDocument   501 /static/errors/501.shtml
    ErrorDocument   503 /static/errors/503.shtml
    ErrorDocument   507 /static/errors/507.shtml
</IfModule>

# robots.txt
Alias /robots.txt /usr/share/lcgdm-dav/robots.txt

# favicon.ico
Alias /favicon.ico /usr/share/lcgdm-dav/icons/favicon.ico

# Compress text output (i.e. directory listings)
# This can reduce really _a_lot_ the response time for big directories.
AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css

# Load all required modules for our own
<IfModule !mime_magic_module>
  LoadModule mime_magic_module  /usr/lib64/httpd/modules/mod_mime_magic.so
</IfModule>
<IfModule !dav_module>
  LoadModule dav_module         /usr/lib64/httpd/modules/mod_lcgdm_dav.so
</IfModule>

# Alias for the delegation
ScriptAlias /gridsite-delegation "/usr/libexec/gridsite/cgi-bin/gridsite-delegation.cgi"

# The location of the base dmlite configuration file
NSDMLite /etc/dmlite.conf

# Is this a DPM Head Node or a LFC?
NSType DPM

# Base path for nameserver requests
<LocationMatch "^/dpm.*">

  LoadModule lcgdm_ns_module      /usr/lib64/httpd/modules/mod_lcgdm_ns.so

  # Enable LCGDM DAV here
  DAV nameserver

  # None, one or several flags
  # Write      Enable write access
  # NoAuthn    Disables user authentication
  # RemoteCopy Enables third party copies
  NSFlags

  # Use this user for anonymous access
  # It has to be in the mapfile!
  NSAnon nobody

  # On redirect, maximum number of replicas in the URL
  # (Used only by LFC)
  NSMaxReplicas 3

  # Redirect using SSL or plain HTTP? Default is On
  NSSecureRedirect On

  # Redirection ports
  # Two parameters: unsecure (plain HTTP) and secure (HTTPS)
  # NSRedirectPort 80 443

  # List of trusted DN (as X509 Subject).
  # This DN can act on behalf of other users using the HTTP headers:
  # X-Auth-Dn
  # X-Auth-FqanN (Can be specified multiple times, with N starting on 0, and incrementing)
  # NSTrustedDNS "/DC=ch/DC=cern/OU=computers/CN=trusted-host.cern.ch"

  # If mod_gridsite does not give us information about the certificate, this
  # enables mod_ssl to pass environment variables that can be used by mod_lcgdm_ns
  # to get the user DN.
  SSLOptions +StdEnvVars

</LocationMatch>

DiskDMLite /etc/dmlite.conf

# Filesystem location
<LocationMatch "^/(?!(dpm|static|icons|robots.txt|favicon.ico)).*">

  LoadModule lcgdm_disk_module    /usr/lib64/httpd/modules/mod_lcgdm_disk.so

  # Enable LCGDM DAV here
  DAV disk
  
  # Head node callback endpoint
  # This is used internally so the disk can do namespace operations
  # (i.e. setting the checksum)
  # Note that for this to work, the disk must be trusted by the Head
  # (Check NSTrustedDNS)
  # NSServer localhost 443

  # None, one or several flags
  # Write      Enable write access
  # RemoteCopy Allow the COPY method
  # NoAuthn    Disables user authentication
  DiskFlags

  # Use this user for anonymous access
  # It has to be in the mapfile!
  DiskAnon nobody

  # Delegation service. If it does not start with http:/https:,
  # https will be assumed, and the host name appended.
  DiskProxyDelegationService /gridsite-delegation

  # Where delegation proxies are stored. This is hard-coded in the GridSite
  # CGI, it allways has to be DocumentRoot/../proxycache
  DiskProxyCache /var/www/proxycache

  # If mod_gridsite does not give us information about the certificate, this
  # enables mod_ssl to pass environment variables that can be used by mod_lcgdm_ns
  # to get the user DN.
  SSLOptions +StdEnvVars

</LocationMatch>

# 
# This is the plain HTTP LCGDM DAV VirtualHost.
#
<VirtualHost *:80>

</VirtualHost>

# 
# This is the SSL enabled LCGDM DAV VirtualHost.
# WARN: If the _default_ VirtualHost is already defined in ssl.conf or in another
# module file, they will have priority over the definition below, and the frontend
# might not work as expected.
#
Listen 443

<VirtualHost *:443>

  LoadModule ssl_module modules/mod_ssl.so

  # To use the LCGDM DAV module you need to enable the SSL directives below.
  # WARN: Check warning above related to SSL directives and the VirtualHost in ssl.conf.
  <IfModule ssl_module>

    LoadModule gridsite_module  /usr/lib64/httpd/modules/mod_gridsite.so

    SSLEngine	on
    SSLProtocol all -SSLv2 -SSLv3

    # Certificates and CAs
    SSLCertificateFile		/etc/grid-security/hostcert.pem
    SSLCertificateKeyFile	/etc/grid-security/hostkey.pem
    SSLCACertificatePath 	/etc/grid-security/certificates
    SSLCARevocationPath		/etc/grid-security/certificates

    # This improves HTTPS performance when the client disables encryption
    SSLCipherSuite 	NULL-MD5:NULL:RC4-MD5:RC4:+LOW:+MEDIUM:+HIGH:+EXP
    SSLHonorCipherOrder on

    # Client verification should be at least optional (see ssl.conf for more information)
    SSLVerifyClient require
    SSLVerifyDepth 10
 
    # Logging
    ErrorLog	logs/ssl_error_log
    TransferLog	logs/ssl_transfer_log
    LogLevel	warn
    CustomLog	logs/ssl_request_log "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"

  </IfModule>

</VirtualHost>
';

Readonly my $DMLITE_EXPECTED_CONFIG => '# This file is managed by Quattor - DO NOT EDIT lines generated by Quattor
#
#
# This is the Apache configuration for the dmlite DAV.
#
# The first part of the file configures all the required options common to all
# VirtualHosts. The actual VirtualHost instances are defined at the end of this file.
#

# Static content
Alias /static/ /usr/share/lcgdm-dav/
<Location "/static">
  <IfModule expires_module>
    ExpiresActive On
    ExpiresDefault "access plus 1 month"
  </IfModule>
  <IfModule include_module>
    Options +Includes
    AddType text/html .shtml
    AddOutputFilter INCLUDES .shtml
  </IfModule>
</Location>

# Custom error messages
# Only make sense if include_module is loaded
<IfModule include_module>
    ErrorDocument   400 /static/errors/400.shtml
    ErrorDocument   403 /static/errors/403.shtml
    ErrorDocument   404 /static/errors/404.shtml
    ErrorDocument   405 /static/errors/405.shtml
    ErrorDocument   409 /static/errors/409.shtml
    ErrorDocument   500 /static/errors/500.shtml
    ErrorDocument   501 /static/errors/501.shtml
    ErrorDocument   503 /static/errors/503.shtml
    ErrorDocument   507 /static/errors/507.shtml
</IfModule>

# robots.txt
Alias /robots.txt /usr/share/lcgdm-dav/robots.txt

# favicon.ico
Alias /favicon.ico /usr/share/lcgdm-dav/icons/favicon.ico

# Compress text output (i.e. directory listings)
# This can reduce really _a_lot_ the response time for big directories.
AddOutputFilterByType DEFLATE text/html text/plain text/xml text/css

# Load all required modules for our own
<IfModule !mime_magic_module>
  LoadModule mime_magic_module  /usr/lib64/httpd/modules/mod_mime_magic.so
</IfModule>
<IfModule !dav_module>
  LoadModule dav_module         /usr/lib64/httpd/modules/mod_lcgdm_dav.so
</IfModule>

# Alias for the delegation
ScriptAlias /gridsite-delegation "/usr/libexec/gridsite/cgi-bin/gridsite-delegation.cgi"

# The location of the base dmlite configuration file
NSDMLite /etc/dmlite.conf

# Is this a DPM Head Node or a LFC?
NSType DPM

# Base path for nameserver requests
<LocationMatch "^/dpm.*">

  LoadModule lcgdm_ns_module      /usr/lib64/httpd/modules/mod_lcgdm_ns.so

  # Enable LCGDM DAV here
  DAV nameserver

  # None, one or several flags
  # Write      Enable write access
  # NoAuthn    Disables user authentication
  # RemoteCopy Enables third party copies
NSFlags Write

  # Use this user for anonymous access
  # It has to be in the mapfile!
  NSAnon nobody

  # On redirect, maximum number of replicas in the URL
  # (Used only by LFC)
  NSMaxReplicas 3

  # Redirect using SSL or plain HTTP? Default is On
NSSecureRedirect on

  # Redirection ports
  # Two parameters: unsecure (plain HTTP) and secure (HTTPS)
NSRedirectPort 80 443

  # List of trusted DN (as X509 Subject).
  # This DN can act on behalf of other users using the HTTP headers:
  # X-Auth-Dn
  # X-Auth-FqanN (Can be specified multiple times, with N starting on 0, and incrementing)
  # NSTrustedDNS "/DC=ch/DC=cern/OU=computers/CN=trusted-host.cern.ch"

  # If mod_gridsite does not give us information about the certificate, this
  # enables mod_ssl to pass environment variables that can be used by mod_lcgdm_ns
  # to get the user DN.
  SSLOptions +StdEnvVars

</LocationMatch>

DiskDMLite /etc/dmlite.conf

# Filesystem location
<LocationMatch "^/(?!(dpm|static|icons|robots.txt|favicon.ico)).*">

  LoadModule lcgdm_disk_module    /usr/lib64/httpd/modules/mod_lcgdm_disk.so

  # Enable LCGDM DAV here
  DAV disk
  
  # Head node callback endpoint
  # This is used internally so the disk can do namespace operations
  # (i.e. setting the checksum)
  # Note that for this to work, the disk must be trusted by the Head
  # (Check NSTrustedDNS)
  # NSServer localhost 443

  # None, one or several flags
  # Write      Enable write access
  # RemoteCopy Allow the COPY method
  # NoAuthn    Disables user authentication
DiskFlags Write

  # Use this user for anonymous access
  # It has to be in the mapfile!
  DiskAnon nobody

  # Delegation service. If it does not start with http:/https:,
  # https will be assumed, and the host name appended.
  DiskProxyDelegationService /gridsite-delegation

  # Where delegation proxies are stored. This is hard-coded in the GridSite
  # CGI, it allways has to be DocumentRoot/../proxycache
  DiskProxyCache /var/www/proxycache

  # If mod_gridsite does not give us information about the certificate, this
  # enables mod_ssl to pass environment variables that can be used by mod_lcgdm_ns
  # to get the user DN.
  SSLOptions +StdEnvVars

</LocationMatch>

# 
# This is the plain HTTP LCGDM DAV VirtualHost.
#
<VirtualHost *:80>

</VirtualHost>

# 
# This is the SSL enabled LCGDM DAV VirtualHost.
# WARN: If the _default_ VirtualHost is already defined in ssl.conf or in another
# module file, they will have priority over the definition below, and the frontend
# might not work as expected.
#
Listen 443

<VirtualHost *:443>

  LoadModule ssl_module modules/mod_ssl.so

  # To use the LCGDM DAV module you need to enable the SSL directives below.
  # WARN: Check warning above related to SSL directives and the VirtualHost in ssl.conf.
  <IfModule ssl_module>

    LoadModule gridsite_module  /usr/lib64/httpd/modules/mod_gridsite.so

    SSLEngine	on
    SSLProtocol all -SSLv2 -SSLv3

    # Certificates and CAs
SSLCertificateFile /etc/grid-security/hostcert.pem
SSLCertificateKeyFile /etc/grid-security/hostkey.pem
SSLCACertificatePath /etc/grid-security/certificates
SSLCARevocationPath /etc/grid-security/certificates

    # This improves HTTPS performance when the client disables encryption
#    SSLCipherSuite 	NULL-MD5:NULL:RC4-MD5:RC4:+LOW:+MEDIUM:+HIGH:+EXP
#    SSLHonorCipherOrder on

    # Client verification should be at least optional (see ssl.conf for more information)
    SSLVerifyClient require
    SSLVerifyDepth 10
 
    # Logging
    ErrorLog	logs/ssl_error_log
    TransferLog	logs/ssl_transfer_log
    LogLevel	warn
    CustomLog	logs/ssl_request_log "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"

  </IfModule>

</VirtualHost>
SSLSessionCache shmcb:/dev/shm/ssl_gcache_data(1024000)
SSLSessionCacheTimeout 7200
';


###########################
# Tests for DPM head node #
###########################

$CAF::Object::NoAction = 1;
set_caf_file_close_diff(1);

my $cmp = NCM::Component::dpmlfc->new('dpmlfc');
my $config = get_config_for_profile("dpm-config");

set_file_contents($DPM_SYSCONFIG_FILE, $DPM_INITIAL_CONFIG);
set_file_contents($DPNS_SYSCONFIG_FILE, $DPNS_INITIAL_CONFIG);
set_file_contents($RFIO_SYSCONFIG_FILE, $RFIO_INITIAL_CONFIG);
set_file_contents($SRMV1_SYSCONFIG_FILE, $SRMV1_INITIAL_CONFIG);
set_file_contents($SRMV2_SYSCONFIG_FILE, $SRMV2_INITIAL_CONFIG);
set_file_contents($SRMV22_SYSCONFIG_FILE, $SRMV22_INITIAL_CONFIG);
set_file_contents($DMLITE_CONFIG_FILE, $DMLITE_INITIAL_CONFIG);

$cmp->configureNode($DPM_HEAD_HOST,$config);

# DPM
my $fh = get_file($DPM_SYSCONFIG_FILE);
ok(defined($fh), "$DPM_SYSCONFIG_FILE was opened");
is("$fh",$DPM_EXPECTED_CONFIG,"$DPM_SYSCONFIG_FILE has expected contents");
$fh->close();

# DPNS
$fh = get_file($DPNS_SYSCONFIG_FILE);
ok(defined($fh), "$DPNS_SYSCONFIG_FILE was opened");
is("$fh",$DPNS_EXPECTED_CONFIG,"$DPNS_SYSCONFIG_FILE has expected contents");
$fh->close();

# RFIO
$fh = get_file($RFIO_SYSCONFIG_FILE);
ok(defined($fh), "$RFIO_SYSCONFIG_FILE was opened");
is("$fh",$RFIO_EXPECTED_CONFIG,"$RFIO_SYSCONFIG_FILE has expected contents");
$fh->close();

# SRM v1
$fh = get_file($SRMV1_SYSCONFIG_FILE);
ok(defined($fh), "$SRMV1_SYSCONFIG_FILE was opened");
is("$fh",$SRMV1_EXPECTED_CONFIG,"$SRMV1_SYSCONFIG_FILE has expected contents");
$fh->close();

# SRM v2
$fh = get_file($SRMV2_SYSCONFIG_FILE);
ok(defined($fh), "$SRMV2_SYSCONFIG_FILE was opened");
is("$fh",$SRMV2_EXPECTED_CONFIG,"$SRMV2_SYSCONFIG_FILE has expected contents");
$fh->close();

# SRM v2.2
$fh = get_file($SRMV22_SYSCONFIG_FILE);
ok(defined($fh), "$SRMV22_SYSCONFIG_FILE was opened");
is("$fh",$SRMV22_EXPECTED_CONFIG,"$SRMV22_SYSCONFIG_FILE has expected contents");
$fh->close();

# dmlite (DAV)
$fh = get_file($DMLITE_CONFIG_FILE);
ok(defined($fh), "$DMLITE_CONFIG_FILE was opened");
is("$fh",$DMLITE_EXPECTED_CONFIG,"$DMLITE_CONFIG_FILE has expected contents");
$fh->close();

# DPM init script for all enabled daemons
$fh = get_file($DPM_INITD_SCRIPT);
ok(defined($fh), "$DPM_INITD_SCRIPT was opened");
is("$fh",$DPM_INITD_EXPECTED,"$DPM_INITD_SCRIPT has expected contents");
$fh->close();

Test::NoWarnings::had_no_warnings();
