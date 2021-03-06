! ************************************************************************
!
!               miniGhost: stencil computations with boundary exchange.
!                 Copyright (2012) Sandia Corporation
!
! Under terms of Contract DE-AC04-94AL85000, there is a non-exclusive
! license for use of this work by or on behalf of the U.S. Government.
!
! This library is free software; you can redistribute it and/or modify
! it under the terms of the GNU Lesser General Public License as
! published by the Free Software Foundation; either version 2.1 of the
! License, or (at your option) any later version.
!
! This library is distributed in the hope that it will be useful, but
! WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
! Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public
! License along with this library; if not, write to the Free Software
! Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
! USA
! Questions? Contact Richard F. Barrett (rfbarre@sandia.gov) or
!                    Michael A. Heroux (maherou@sandia.gov)
!
!
! ************************************************************************

MODULE MG_OVER_DIAGS_MOD

   ! Purpose
   ! =======
   ! OVER boundary exchange for 9- and 27-point stencils:
   !    pack, send, receive, unpack.

   USE MG_CONSTANTS_MOD
   USE MG_UTILS_MOD
   USE MG_IRECV_MOD
   USE MG_PACK_MOD
   USE MG_SEND_OVER_MOD
   USE MG_UNPACK_OVER_MOD

   IMPLICIT NONE

   ! Note: Using 0-based indexing on arrays.

CONTAINS
   
   SUBROUTINE MG_OVER_DIAGS ( IVAR, IERR )
   
      ! -------------------------------------------------------
      ! Pack all variables for single message to each neighbor.
      ! -------------------------------------------------------

      ! ---------------------
      ! Argument Declarations
      ! ---------------------

      INTEGER, INTENT(IN) :: &
         IVAR           ! Return status

      INTEGER, INTENT(OUT) :: &
         IERR           ! Return status

      ! ------------------
      ! Local Declarations
      ! ------------------
   
      INTEGER :: &
         ICOUNT,                      &  ! Message size.
         ISTAT,                       &  ! MPI return status.
         IWHICH,                      &  ! MPI_Wait_any SRC process
         I, J, K, L, M, N,            &  ! Counters
         NUM_RECVS,                   &
         NUM_RECVS_OUTSTANDING,       &
         MSG_REQ_OFFSET,              &
         OFFSET,                      &
         OFFSET_LAST,                 &
         RECV_BUFFER_SIZE,            &
         SEND_BUFFER_SIZE,            &
         MSG_REQ(12)
   
      ! ---------------------
      ! Executable Statements
      ! ---------------------

      IERR = 0

      COUNT_SEND_NORTH = 0
      COUNT_SEND_SOUTH = 0
      COUNT_SEND_EAST  = 0
      COUNT_SEND_WEST  = 0
      COUNT_SEND_BACK  = 0
      COUNT_SEND_FRONT = 0
   
      SELECT CASE ( IVAR )

         CASE ( 1 )
            CALL MG_OVER_DIAGS_GRID ( GRID1, IERR )
         CASE ( 2 )
            CALL MG_OVER_DIAGS_GRID ( GRID2, IERR )
         CASE ( 3 )
            CALL MG_OVER_DIAGS_GRID ( GRID3, IERR )
         CASE ( 4 )
            CALL MG_OVER_DIAGS_GRID ( GRID4, IERR )
         CASE ( 5 )
            CALL MG_OVER_DIAGS_GRID ( GRID5, IERR )
         CASE ( 6 )
            CALL MG_OVER_DIAGS_GRID ( GRID6, IERR )
         CASE ( 7 )
            CALL MG_OVER_DIAGS_GRID ( GRID7, IERR )
         CASE ( 8 )
            CALL MG_OVER_DIAGS_GRID ( GRID8, IERR )
         CASE ( 9 )
            CALL MG_OVER_DIAGS_GRID ( GRID9, IERR )
         CASE ( 10 )
            CALL MG_OVER_DIAGS_GRID ( GRID10, IERR )
            
         CASE ( 11 )
            CALL MG_OVER_DIAGS_GRID ( GRID11, IERR )
         CASE ( 12 )
            CALL MG_OVER_DIAGS_GRID ( GRID12, IERR )
         CASE ( 13 )
            CALL MG_OVER_DIAGS_GRID ( GRID13, IERR )
         CASE ( 14 )
            CALL MG_OVER_DIAGS_GRID ( GRID14, IERR )
         CASE ( 15 )
            CALL MG_OVER_DIAGS_GRID ( GRID15, IERR )
         CASE ( 16 )
            CALL MG_OVER_DIAGS_GRID ( GRID16, IERR )
         CASE ( 17 )
            CALL MG_OVER_DIAGS_GRID ( GRID17, IERR )
         CASE ( 18 )
            CALL MG_OVER_DIAGS_GRID ( GRID18, IERR )
         CASE ( 19 )
            CALL MG_OVER_DIAGS_GRID ( GRID19, IERR )
         CASE ( 20 )
            CALL MG_OVER_DIAGS_GRID ( GRID20, IERR )

         CASE ( 21 )
            CALL MG_OVER_DIAGS_GRID ( GRID21, IERR )
         CASE ( 22 )
            CALL MG_OVER_DIAGS_GRID ( GRID22, IERR )
         CASE ( 23 )
            CALL MG_OVER_DIAGS_GRID ( GRID23, IERR )
         CASE ( 24 )
            CALL MG_OVER_DIAGS_GRID ( GRID24, IERR )
         CASE ( 25 )
            CALL MG_OVER_DIAGS_GRID ( GRID25, IERR )
         CASE ( 26 )
            CALL MG_OVER_DIAGS_GRID ( GRID26, IERR )
         CASE ( 27 )
            CALL MG_OVER_DIAGS_GRID ( GRID27, IERR )
         CASE ( 28 )
            CALL MG_OVER_DIAGS_GRID ( GRID28, IERR )
         CASE ( 29 )
            CALL MG_OVER_DIAGS_GRID ( GRID29, IERR )
         CASE ( 30 )
            CALL MG_OVER_DIAGS_GRID ( GRID30, IERR )
            
         CASE ( 31 )
            CALL MG_OVER_DIAGS_GRID ( GRID31, IERR )
         CASE ( 32 )
            CALL MG_OVER_DIAGS_GRID ( GRID32, IERR )
         CASE ( 33 )
            CALL MG_OVER_DIAGS_GRID ( GRID33, IERR )
         CASE ( 34 )
            CALL MG_OVER_DIAGS_GRID ( GRID34, IERR )
         CASE ( 35 )
            CALL MG_OVER_DIAGS_GRID ( GRID35, IERR )
         CASE ( 36 )
            CALL MG_OVER_DIAGS_GRID ( GRID36, IERR )
         CASE ( 37 )
            CALL MG_OVER_DIAGS_GRID ( GRID37, IERR )
         CASE ( 38 )
            CALL MG_OVER_DIAGS_GRID ( GRID38, IERR )
         CASE ( 39 )
            CALL MG_OVER_DIAGS_GRID ( GRID39, IERR )
         CASE ( 40 )
            CALL MG_OVER_DIAGS_GRID ( GRID40, IERR )

         CASE DEFAULT
            WRITE(*,*) '** Error ** COMM_MG_OVER: Unknown variable number ', IVAR, '.'

      END SELECT
            
   END SUBROUTINE MG_OVER_DIAGS

   SUBROUTINE MG_OVER_DIAGS_GRID ( GRID, IERR )

      ! -------------------------------------
      ! Exchange messages for this GRID with neighbors
      ! -------------------------------------

      ! ---------------------
      ! Argument Declarations
      ! ---------------------

      INTEGER, INTENT(OUT) :: &
         IERR           ! Return status

      REAL(KIND=MG_REAL), DIMENSION(0:NX+1, 0:NY+1, 0:NZ+1), INTENT(INOUT) :: &
         GRID
      ! ------------------
      ! Local Declarations
      ! ------------------

      INTEGER :: &
         I,           & ! Counter
         DIR(3)         ! Boundary exchange directions

      ! ---------------------
      ! Executable Statements
      ! ---------------------

      IERR = 0

      DIR(1) = DIR_NORTH_SOUTH
      DIR(2) = DIR_EAST_WEST
      DIR(3) = DIR_BACK_FRONT

      DO I = 1, 3

         ! Set only those neighbors participating in this iterative loop.
         NEIGHBORS = -1
         SELECT CASE ( DIR(I) )
            CASE ( DIR_NORTH_SOUTH )
               NEIGHBORS(NORTH) = NEIGHBORS_ORIG(NORTH)
               NEIGHBORS(SOUTH) = NEIGHBORS_ORIG(SOUTH)
            CASE ( DIR_EAST_WEST )
               NEIGHBORS(EAST) = NEIGHBORS_ORIG(EAST)
               NEIGHBORS(WEST) = NEIGHBORS_ORIG(WEST)
            CASE ( DIR_BACK_FRONT )
               NEIGHBORS(BACK)  = NEIGHBORS_ORIG(BACK)
               NEIGHBORS(FRONT) = NEIGHBORS_ORIG(FRONT)
         END SELECT

         CALL MG_IRECV ( IERR )
         CALL MG_PACK_SEND ( GRID,  IERR )
!         CALL MG_SEND_OVER ( GRID, IERR )
         CALL MG_UNPACK_OVER ( GRID, IERR )

      END DO ! Loop over DIR

      NEIGHBORS(NORTH) = NEIGHBORS_ORIG(NORTH)
      NEIGHBORS(SOUTH) = NEIGHBORS_ORIG(SOUTH)
      NEIGHBORS(EAST)  = NEIGHBORS_ORIG(EAST)
      NEIGHBORS(WEST)  = NEIGHBORS_ORIG(WEST)
      NEIGHBORS(FRONT) = NEIGHBORS_ORIG(FRONT)
      NEIGHBORS(BACK)  = NEIGHBORS_ORIG(BACK)

   END SUBROUTINE MG_OVER_DIAGS_GRID
   
END MODULE MG_OVER_DIAGS_MOD
