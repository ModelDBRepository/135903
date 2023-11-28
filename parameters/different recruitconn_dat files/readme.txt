These are just variations of the recruitconn.dat file, to include various combinations of gap junctions, recurrent axons, basket cell connections.


1.  recruitconnbasicnoneighbor.dat  This is the same connectivity as our 2009 paper with "conn.dat".  It only has connections among the "driver" cells and baskets
2.  recruitconnwithneighborFB.dat  Same as above, but with 20 Neighbor cells added in.  They have the same feedback (FB) as the Drivers, meaning they
	have all 80 basket cells synapsing onto them (GABA), and make 2 or 3 AMPA synapses onto random baskets, exactly like the 80 driver cells
3.  recruitconn_nbFB_rec.dat  same as #2, but with recurrent synapses from 20 Drivers onto 20 Neighbors
4.  recruitconn_nbFB_gaps.dat  same as #3, but instead of recurrent synapses there are gap junctions between the 20 pairs

  


The "../recruitconn.dat" that is in the .zip file is #4, with gaps.