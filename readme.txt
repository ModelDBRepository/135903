Recruitment in Hippocampal HFOs Model README file
=====================================================

This model creates the 120-cell hippocampal model in:

Stacey WC, Krieger A, and Litt B. (2011) Network recruitment to
coherent oscillations in a hippocampal computer model.
Journal of Neurophysiology 105(4):1464-1481.


To run the simulation
---------------------

1. Should be run in the normal (serial) installation of NEURON 6.1 or
above.  Most of the code is actually written for parallel
implementation, but several functions were added that are not able to
run in parallel.

2. Unpack the zip file, keeping the file structure intact (see below)

3. Compile the nrnmech file within the \mod directory according to
your system's requirements.  Move the nrnmech file to the root
directory.

4. Run recruit.hoc.

5. Currently the network creates the three files demonstrated in
Fig. 3.  Other specific parameters to simulate different conditions
need to be set as follows :

        within recruit.hoc
                Tstop           length of simulation in ms
                pyrthr          the threshold to which the random number
                                (0-100) is compared.  rnd > pyrthr
                                will create a noise event
                basketthr       same as above for synapses to basket cells
                gapstyle        whenever you alter the files in \parameters,
                                change this number and record what the
                                changes were
                sigfreq         frequency of periodic signal.  Not used in
                                this simulation

                driverthr       Noise level to the Drivers.  this number is
                                held constant, and saved in the
                                filename as "_f##"
                                >>>the four levels tested were: 55 (95
                                   Hz), 65 (75 hz), 80 (50 hz), 85 (40
                                   Hz)
                                
        within \parameters\recruitconn.dat

                this file lists all synaptic and gap junctional
                connections, based on the parameters of synapses.par

                the current recruitconn.dat has the full feedback
                network of pyr - basket - pyr connections described.
                >>>>It also has gap junctions between 20 Drivers and
                    the 20 Neighbors.

                there are several additional recruitconn.dat files in
                the attached folder.  These simply need to be moved to
                the \parameters directory and renamed "conn.dat"

        \parameters\synapses.par

                Here the gmax of the synapses is changed.  For this
                paper, the gmax of the IE and EI synapses was
                constant.

                This was used to change the gap junctions' gmax to 0,
                0.01, or 0.001 in the last line.  >>>>It is currently
                set to 0.001

The matlab analysis uses the file "figureanal.m", which calls
"tricolorspikeraster.m"

FILE EXPLANATIONS
=================

Program run in the root directory, and calls files in several branched
directories as listed below.  The program is run from a batch file
that saves several parameters into the file names

Note that the program was originally written in parallel format, and
is based on legacy code written by Maciej Lazarewicz that was some of
the first parallel code used in NEURON, before the parallel version
was out of alpha.  There have been many modifications since then, some
of which do not work in parallel.  It is for this reason that the gap
junctions were done with the parallel format directly in the TGnet.tem
rather than the pointer method.

Unfortunately, the parallel idiom, which is slightly different even
than the current standard parallel idiom, can make this code difficult
to follow.  Because of several reasons, this code is not ready for
parallel implementation.  However, it is an excellent candidate for
the "bulletin board" style parallel that is currently being developed.
        

root folders:
        
        \templates

                ****recruitnet.tem //main program to build the network
                                     and gene rate stimuli and noise
                ****PYRkop.tem  //template for the pyramidal cells
                ****Bwb.tem  //template for basket cells                
                Ok.tem    // Okn cells not used
                several others  //not used
                
        \mod
                has all the channels, synapses, and gap(not used) .mod files
                
        \parameters

                // this folder is where the connectivity and
                conductance values are changed for different runs has
                .dat and .par files that contain the parameters that
                will be read in
                These files must be manually altered to change the
                        parameters.  I used the parameter "gapstyle"
                        in the netrun.hoc to indicate which parameter
                        set I had used for gmax's (had to keep track
                        of this separately" also have .tem files for
                        cells and synapses

                
        \library
                //not used
        \data
                // all data saved here.  Each run creates a different
                filename to be saved


The main folder has the .hoc executable (there are many different
versions, all variations of below)
          *****recruit.hoc   //main .hoc file
                loads in /templates/recruitnet.tem
                sets many flags and parameters
                DoRun() is the main executable
                        pr = new TGnet()   //from template folder

                                which contains all functions in
                                recruitnet.tem, as well as having
                                .pnm. class
                        pr.pnm.want_all_spikes()

                        pr.activeSynapsesRandom(.....)  generates
                                random synaptic events in all the
                                cells
                        pr.signalSynapse(....)  adds a periodic input
                                to a specific pyramidal cell
                        pr.pnm.psolve(Tstop)
                        pr.pnm.gatherspikes()
                        writes files per flags
                        pr.pnm.pc.gid_clear()

                I make runs of files by changing parameters then
                calling DoRun(), over and over


Note that, although written in pnm.pc format, I have never compiled
NEURON that way--I've just run it in basic serial format.
