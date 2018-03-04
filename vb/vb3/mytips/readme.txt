README FILE FOR MYTTIPS.

(c) 1996 Gabriele Del Giovine
         SOFTWARE & NETWORKS TECHNOLOGIES
         Via G. Amadio, 57
         64010 CONTROGUERRA (TE) - ITALY
         E-mail mc6491@mclink.it
         COMPUSERVE 72660,1344


READ THIS FIRST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
This software is FREEWARE. No warranties or liabilities.



This implementation of ToolTips are made only with standard VB resource 
and with few API calls. No VBX's or OCX's. Also MYTTIPS use only one
timer control for all windows with tooltips.

How use MyTTYPS?

First you must add the TTIPS.* files into your project.....

Then for each form with controls that you like associate with ToolTips
inser this code on Form.Activate events:

-- Begin of example code ---------------------

Form1.Activate ()

InitializeTips
AddTip ControlWithTip.Hwnd,"The Tip","The Help for a big tip"
AddTip OtherControlWithTip.Hwnd,"The Other Tip","The Help for a big tip"
AddTip NewControlWithTip.Hwnd,"The New Tip","The Help for a big tip"

End sub

-- End of sample code ------------------------

Well, now you must add the following code on form1.MouseMove events

-- Begin of example code ---------------------

Form1.MouseMove ......

DisplayTips

End sub

-- End of sample code ------------------------

NOTE:
If your control is placed into a container you must add the 'DisplayTips' 
call into the container MouseMove Events.

When you are tired of Tip for a particular control you can remove it from
the ToolTips list using the call

RemoveTip RemovingControl.Hwnd


Ok folks this is all to do.

Who appreciate my efforts can send to me a gift, like
cars (Ferrari,BMW,Mercedes),motorcycles (only Harley Davidson please..)
or a post-card......(also your credit-card.....)

Bye Bye







On 




