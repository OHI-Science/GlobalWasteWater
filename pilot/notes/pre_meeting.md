# Pre-Meeting Notes

This is just a dump of what I currently know about the project (before the Jan 23rd first meeting), 
and maybe a bit of what I want to know by the end of the meeting.

## Mazu details from Mel:

> Here is folder of interest:
> Mazu: ohi/marine_threats/impact_layers_2013_redo/impact_layers/work/land_based

> The following is my interpretation of the folders/files (but view this information skeptically because I have never actually performed this analysis):

> I think you will want to start by looking through the “documentation” folder. I think this provides an overview of the general workflow.

> I think the folder you will actually be working from is “before_2007” (which counter-intuitively includes stuff after 2007).

> The folder of “jb_repro” is something that I believe Julien Bruen created. You should definitely chat with Julien about this folder (and the overall project) because he has run this analysis in the past!  I’m not sure what this specific folder includes, but I seem to remember that he made a correction to something…and it might be in this folder.

> I don’t think these files are important:

> “scripts_only” and “scripts_and_intermediary_layers”: I think you can probably ignore these, I think we put these together for someone else

> “final_products”: I am pretty sure these are old results that you can ignore.

> 2 more things:

> I think it will be best to start a new folder for your work and copy things over as needed and relabel folders in a way that makes sense.  Maybe here: mazu: ohi/git-annex/land-based/wastewater

> I think one of the final steps in the analysis is to rescale the data between 0-1 using max values across the raster.  When you do the wastewater analysis, please eliminate this step and stop at the “raw” values.

## Specific Questions:

- [ ] Is there a project proposal or something I could look at? I like to refer back to what's actually been promised so I don't go off on tangents.
- [ ] Are we recreating the watersheds (as described in online materials), or are we using them as a static input?
- [ ] Are we including the sources from the orginal or just wastewater outflows?
