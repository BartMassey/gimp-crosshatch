# Crosshatch-Fu
A Gimp Crosshatch Script-Fu filter  
Copyright © 2011 Bart Massey  
`bart.massey@gmail.com`  
2011-07-20

This filter started with a need for an etching of Lewis
Carroll for a talk I gave at the Open Source Bridge
Conference 2011. It turns out I couldn't easily find one, so
I looked for a GIMP plugin to process a photo into a
synthetic etching. After some digging around, the most
promising thing I could find was a Perl plug-in posted by
Sam Jones in 2001 to an email list.

I've taken Jones's plugin as an inspiration, and written a
GUILE Scheme Script-Fu plugin with similar operation.  My
plugin produces marginal-quality synthetic etchings.

<blockquote><table><tr><img src="bart-grey.png" alt="before"/></tr>
<tr><img src="bart-hatched.png" alt="after"/></tr></table></blockquote>

If you like, the code will leave the layers it constructed
lying around when it is done; you can adjust each layer as
desired and then merge them manually. The layers are a
"penciled-in" layer, with NW and NE crosshatch layers above
that.

# Installation

Install this just like any other Gimp Script-Fu plugin. For
Linux and Mac OS X, this means copying `crosshatch.scm` to
`~/.gimp-2.6/scripts/` and restarting Gimp. For Windows,
copy into `C:\Program Files\GIMP-2.0\share\gimp\2.0\scripts`
or something--I'm not a Windows user, so I don't really
know.

# Future Work

Planned future enhancements include some more control over
the etching. It would be nice to have preview mode, but it
looks like that would require rewriting this code in
something other than Scheme, and I'm not really up for
another rewrite.

# License and Availability

I have placed my code under GPLv2 to clarify GIMP license
compatibility. Please see the file COPYING in this
distribution for license details. I do not believe that my
current code is a derivative work of Sam Jones's code per US
copyright law. I have attempted to contact Sam Jones without
success. Hopefully, he will appear at some point and give
the project his blessing.

This project is currently hosted on GitHub. See its [project
page](http://github.com/BartMassey/gimp-crosshatch) for
source repository information.
