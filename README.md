# EVENTF - A Tools/400 Service Program

EVENTF is service program that offers services for writing events to the IBM compile event file (EVFEVENT).

## Dependencies

Dependencies:

- BASICS1

## Installation

Compile members with the following PDM option:

   STRPREPRC USESRCFILE(&L/&F) USESRCMBR(&N) OPTION(*EVENTF) CHGOBJD(*NO)
     LIB(&O) OBJ(&N) SRCLIB(&L) SRCFILE(&F) SRCMBR(&N) USER0(&X)
     USER1(*LIST) USER2(*FULL)

Members of type MAKPGM or BND are used for linking programs (MAKPGM)
and service programs (BND).

---

2018, Thomas Raddatz
