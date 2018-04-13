/* --------------------------------------------------------------- */
/* EVENTF     - SCRIPT MEMBER                                      */
/* Use commands  xmlgenINC (generate text for install pgm)         */
/*               xmlgenMBR (to define source members               */
/*               xmlgenCMD (execute qcmdexc at run time            */
/* Put &TOLIB where you want user selected lib at run time.        */
   DCL &TOLIB *CHAR 10
/* --------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENCND  XMSG('Create sample programs? (YES, NO)') +
                          XVALUES(YES NO) XVAR(&CRTTSTPGM)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QEVENTF)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CEELIB    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EVENTF    ) XMBRATR(MAKSRV) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EVENTF_H  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EVENTFT1  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EVENTFT2  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EVENTFT3  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EVENTFT4  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(EVENTF1   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDINFDS   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(H_SPEC    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PEVENTF   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QCMDEXC   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QP0LCVTPAT) XMBRATR(RPGLE ) +
                          XFROMSRCF(QEVENTF   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QEVENTF   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/&SRCFILE) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&CRTTSTPGM'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

