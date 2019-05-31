function tricolorspikeraster(spikefile)

%this function takes a spikeraster matrix "spikefile" and plots the raster
%with the Driver pyramidal cells blue, Neighbor pyr black, and baskets red


index=(spikefile(:,2)>80);   %index of baskets and neighbors
bindex=(spikefile(:,2)>100);  %index of basket cells
nindex=~index;  %not index is all 80 and below
neighborindex=((spikefile(:,2)>80) & (spikefile(:,2)<101)) ;
%scatter(spikefile(index,1),spikefile(index,2),3,'k','.')
scatter(spikefile(neighborindex,1),spikefile(neighborindex,2),3,'k','.')
hold on
scatter(spikefile(nindex,1),spikefile(nindex,2),3,'b','.')
scatter(spikefile(bindex,1),spikefile(bindex,2),3,'r','.')   %overdraws the baskets from index, if neighborindex is not used
hold off
end

% for splitting by halves- index=rem(spikefile(:,2),2);
% workingindex=index==1;
%scatter(spikefile(workingindex,1),spikefile(workingindex,2));
