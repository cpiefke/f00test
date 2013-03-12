(defun ede-proj-target-add-compiler (obj compiler)
  (let ((st (oref obj availablecompilers)))
    (oset-default obj
		  availablecompilers
		  (cons compiler st))))

(defun ede-proj-target-add-sourcetype (obj source)
  (let ((st (oref obj sourcetype)))
    (oset-default obj
		  sourcetype
		  (cons sourcet st))))

(defun ede-proj-target-add-linker (obj linker)
  (let ((st (oref obj availablelinkers)))
    (oset-default obj
		  availablelinkers
		  (cons linker st))))


;;; iFort Compiler/Linker
;;
;;
(defvar ede-ifort-compiler
  (ede-object-compiler
   "ede-f90-compiler-ifort"
   :name "ifort"
   :dependencyvar '("F90_DEPENDENCIES" . "-Wp,-MD,.deps/$(*F).P")
   :variables '(("F90" . "ifort")
		("F90_COMPILE" .
		 "$(F90) $(DEFS) $(INCLUDES) $(F90FLAGS)"))
   :rules (list (ede-makefile-rule
		 "f90-inference-rule"
		 :target "%.o"
		 :dependencies "%.f90"
		 :rules '("@echo '$(F90_COMPILE) -c $<'; \\"
			  "$(F90_COMPILE) $(F90_DEPENDENCIES) -o $@ -c $<"
			  )
		 ))
   :sourcetype '(ede-source-f90 ede-source-f77)
   :objectextention ".o"
   :makedepends t
   :uselinker t)
  "iFort Compiler for Fortran sourcecode.")

(defvar ede-ifort-module-compiler
  (clone ede-ifort-compiler
 	 "ede-f90-module-compiler-ifort"
 	 :name "ifortmod"
 	 :sourcetype '(ede-source-f90)
 	 :commands '("$(F90_COMPILE) -c $^")
 	 :objectextention ".mod"
 	 :uselinker nil)
  "iFort Compiler for Fortran 90/95 modules.")


(defvar ede-ifort-linker
  (ede-linker
   "ede-ifort-linker"
   :name "ifort"
   :sourcetype '(ede-source-f90 ede-source-f77)
   :variables  '(("F90_LINK" . "$(F90) $(CFLAGS) $(LDFLAGS) -L."))
   :commands '("$(F90_LINK) -o $@ $^")
   :objectextention "")
  "Linker needed for Fortran programs.")




(ede-proj-target-add-compiler ede-proj-target-makefile-objectcode 'ede-ifort-compiler)
(ede-proj-target-add-compiler ede-proj-target-makefile-objectcode 'ede-ifort-module-compiler)

(ede-proj-target-add-compiler ede-proj-target-makefile-archive 'ede-ifort-compiler)

(ede-proj-target-add-compiler ede-proj-target-makefile-program 'ede-ifort-compiler)
(ede-proj-target-add-compiler ede-proj-target-makefile-program 'ede-ifort-module-compiler)
(ede-proj-target-add-linker ede-proj-target-makefile-program 'ede-ifort-linker)


