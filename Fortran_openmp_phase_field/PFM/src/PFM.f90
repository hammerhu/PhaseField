Program INTERCRITICAL_ANNEALING
! THIS PROGRAM IS TO SIMULATE INTERCRITICAL ANNEALING USING THE MULTIPHASE FIELD APPROACH DEVELOPED BY INGO STEINBACH.
! THE MODEL CONSISTS OF THREE SUB-MODELS:(1) FERRITE RECRYSTALLIZATION; (2) AUSTENITE FORMATION; (3) AUSTENITE TO FERRITE TRANSFORMATION.
! THE MODEL USES 2D SIMULATION DOMAIN. THE PHASE FIELD EQUATIONS ARE SOLVED NUMERICALLY USING FINITE DIFFERENCE: FORWARD EULER METHOD IN THE TIME SCALE AND 5-POINT STENCIL FOR THE LAPLACIAN.
! PERIODIC BOUNDARY CONDITIONS ARE USED BY DEFAULT.
! FOR FURTHER INFORMATION, PLEASE CONTACT BENQIANG ZHU BY EMAIL: ZHUBENQIANG@GMAIL.COM
! OR REFER TO THE PAPER: B Zhu and M Militzer 2012 Modelling Simul. Mater. Sci. Eng. 20 085011

 ! THIS FILE IS THE ENTRY OF THE PROGRAM.
 ! Use PRE_PROCESS:             INITIALIZATION OF THE PROGRRAM, SUCH AS MICROSTRUCTURE CONSTRUCTION, AND CONTAINS SUBROUTINE: INPUT_AND_INITIALIZE()
 ! Use MODULE_NUCLEATION:       CONTAINS NUCLEATION SUBROUTINES: NUCLEATION_REX_ALPHA(N),NUCLEATION_AUSTENITE()
 ! Use SPARSE:                  CONTAINS PHASE FIELD SOLVER AND TIMESTEP CONTROL SUBROUTINES: SOLVER(),TIMESTEP()
 
      Use PRE_PROCESS
      Use MODULE_NUCLEATION
      Use SPARSE
      
     
      Implicit None
      

      ! INITIALIZATION OF THE SIMULATION
      Call INPUT_AND_INITIALIZE()
      ! NUCLEATION FOR FERRITE RECRYSTALLIZATION, ALPHA_NUC_N IS THE NUCLEI NUMBER
      Call NUCLEATION_REX_ALPHA (alpha_nuc_n)

     ! SOLVE PHASE FIELD EQUATIONS WITH A TIME STEP OF DEL_T, TIME AND TEMPERATURE EVOLVES IN EACH LOOP.
      Do WHILE (Time <= Final_t)

         Call TIMESTEP()

         Call NUCLEATION_AUSTENITE()

         Call SOLVER()

         Time = Del_t + Time
         !TEMPERATURE PATH
         Call T_PROFILE ()
         ! OUTPUT DATA
         If ( Abs(Time-Write_t*Nint(Time/Write_t)) <= Del_t/2. ) Then            
            
            Call WRITE_GRAIN_DATA (Time, Micro_out)

         End If
      End Do

      Write (*,*) "AUSTENITE_SIZE:", AVG_SIZE (2)
      Write (*,*) "NEW FERRITE SIZE:", AVG_SIZE (4)
      Write (*,*) "SIMILATION COMPLETED   ^-^"

End Program

