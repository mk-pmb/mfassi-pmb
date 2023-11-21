
<!--#echo json="package.json" key="name" underline="=" -->
mfassi-pmb
==========
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Multi Factor (Login) Assistant. Not meant as a security tool!
<!--/#echo -->


Looking for security? Use something else.
-----------------------------------------

This tool is __NOT__ meant to help you increase your security.

Instead, this tool is meant to help me cope with obnoxious
blame-deflecting security theater nonsense that has become
waaaaay too popular with websites that give a █████ about your
account security but decide to don a cheap fig leaf to blame
__you__ in case __they__ overshare their passwords database.


#### Why do you hate multi factor authentification?

I don't. I actually really like to have that option, __IF__
it's done in a useful way that actually increases my security.
Like when I can prove my identity to my local device (using any
method I deem fit) to unlock an SSH or GPG key that I can then
use to identify to the website in a mostly automated way.
In that utopia, website logins would actually become __easier__
with better tech, rather than more annoying.


#### So what you really want are passkeys?

Yeah. [Passkeys](https://en.wikipedia.org/wiki/Passkey_%28credential%29)
would totally solve that usability problem. (And also a big part
of the security concern.)

Unfortunately, a lot of websites still don't accept them.
Also I cannot figure out how to easily hook Firefox up with my
credentials manager. Seems like I would have to write a custom
browser addon. No thanks.


#### Why re-invent your own password manager?

It's not meant to be one. Ideally you configure `mfassi` to use your
own credentials management software.

* Consider keeping the spirit of MFA by storing your MFA keys on another
  machine than your password.
  USB UART adapters are an easy¹ and cool way to transmit short texts
  between computers without a need for all the complexity (and thus attack
  surface) of a full network connection.
  <br>(¹ Get two of them, connect both their GND wires and pair each TX to RX.
  Avoid sending while your neighbor is pointing a suspiciously large antenna
  dish at them.)
* If you store password and MFA keys as plain text,
  consider at least minimizing the duration of exposure, e.g. store the file
  on a USB thumb drive that you only connect when needed, or on an encrypted
  file system that you only mount temporarily.




Usage
-----

:TODO:



<!--#toc stop="scan" -->



Known issues
------------

* Needs more/better tests and docs.




&nbsp;


License
-------
<!--#echo json="package.json" key=".license" -->
ISC
<!--/#echo -->
