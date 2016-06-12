# gem5 Ruby analysis

This repo contains some simulations of the Ruby protocols under several system variations.

## Folder structure
The following folder structure is supposed :

```
 <REPO_PATH>/
     + <benchmark1>/
         + <protocol1>/
             + <variation_type1>/
	             + <variation1>
	             + <variation2>
	             ...
	         + <variation_type2>/
	             ...
	     + <protocol2>/
	         ...
```

where `<benchmarkX>` corresponds to the workload to run by gem5, `<protocolX>` corresponds 
to the Ruby protocol used for the simulation, `<variation_typeX>` to the parameter to vary 
and finally `<variationX>` to the parameter value for that given simulation. Each leaf folder
contains the output files of the simulation and more especially the `stats.txt` file.

## Running the simulations
The Bash scripts have been written to run on a particular setup and need to be refactored.
