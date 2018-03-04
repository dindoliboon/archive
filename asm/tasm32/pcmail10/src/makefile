#note: W32.LIB I created using IMPLIB of kernel32.dll, user32.dll, shell32.dll
NAME = pcmail
OBJS = $(NAME).obj
DEF  = $(NAME).def

TASMDEBUG=
LINKDEBUG=

IMPORT=w32.lib

$(NAME).EXE: $(OBJS) $(DEF)
  tlink32 /Tpe /V4.0 /aa /c /m /ml $(OBJS),$(NAME),, $(IMPORT), $(DEF)
  brc32 $(NAME).rc

.asm.obj:
   tasm32 /m /ml $&.asm
