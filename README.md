# Filament_Displacement_imagetool
 Image analytics tool for use in investigating dense microtubule filament dynamics

 The Filament Displacement Image Analytics Tool (FIDI) can be used by researchers to understand the active forcing environment inside of cells.
 We argue that using a combination of a anisotropic rotating Laplacian of Gaussian (LoG) kernel coupled with Optical Flow (OF) can yield the active driving down to microtubules (MTs) in a dense network.

 In this repository, one can find the main functions: fftLoG_fixedPad.m, Log_fixedPad_imsseq.m, LKxOptFlow_allFrames.m, and LoGOFTool_fixedPad.m for use of understanding lateral motion in dense MT networks.
 The use of these scripts is straightforward and further explained in each function.

 Moreover, within this repository, one can find additional downstream tools for making the most out of the information generated from the LoG kernel. Given some biologically revelenat paramter (such as the cell boundary), we can find a filament's relative angle to this boundary. We argue our use of this downstream analysis enhances the benefits of FIDI, and introduces a novel way of thinking about filament dynamics in an active forcing environment. 
