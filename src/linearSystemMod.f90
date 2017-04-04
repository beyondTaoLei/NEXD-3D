!--------------------------------------------------------------------------
!   Copyright 2012-2016 Lasse Lambrecht (Ruhr-Universitaet Bochum, Germany)
!   Copyright 2015-2017 Andre Lamert (Ruhr-Universitaet Bochum, Germany)
!
!   This file is part of NEXD 3D.
!
!   NEXD 3D is free software: you can redistribute it and/or modify it
!   under the terms of the GNU General Public License as published by the
!   Free Software Foundation, either version 3 of the License, or (at your
!   option) any later version.
!
!   NEXD 3D is distributed in the hope that it will be useful, but WITHOUT
!   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
!   FITNESS FOR A PARTICULAR PURPOSE.
!   See the GNU General Public License for more details.
!
!   You should have received a copy of the GNU General Public License v3.0
!   along with NEXD 3D. If not, see <http://www.gnu.org/licenses/>.
!--------------------------------------------------------------------------
module linearSystemMod
  ! module to solve linear systems
	use constantsMod
  implicit none

contains
  subroutine solveLinearSystemQR(A,b,x,nrow,ncol)
    ! INPUT: Matrix A, vector b, number of rows nrow, number of colums ncol
    ! DOES:  solve a overdetermined linear system with QR methode (lapack SGELS) A*x=b
    ! RETURNS: vector b
    real(kind=CUSTOM_REAL), dimension(:,:) :: A
    real(kind=CUSTOM_REAL), dimension(:) :: x
    real(kind=CUSTOM_REAL), dimension(:) :: b
    integer :: nrow,ncol
    real(kind=CUSTOM_REAL), dimension(nrow,ncol) :: A_tmp
    integer :: LDB,LWORK,INFO
    real(kind=CUSTOM_REAL), dimension(:), allocatable :: x_tmp
    real, dimension(:), allocatable :: WORK

    A_tmp = A
    
    LDB = max(nrow,ncol)
    allocate(x_tmp(LDB))
    x_tmp(:) = 0.
    x_tmp(1:nrow) = b(:)
    allocate(WORK(1));
    LWORK = -1

    call SGELS( 'N', nrow, ncol, 1, A_tmp, nrow, x_tmp, LDB, WORK, LWORK,INFO )
    if(INFO/=0) then
       write(*,*) "Error in solveLinearSystemQR: LWORK"
       stop
    end if
    
    LWORK = WORK(1)
    deallocate(WORK)
    allocate(WORK(LWORK))
    call SGELS( 'N', nrow, ncol, 1, A_tmp, nrow, x_tmp, LDB, WORK, LWORK,INFO )
    if(INFO/=0) then
       write(*,*) "Error in solveLinearSystemQR: Solve"
       stop
    end if
    x=x_tmp(1:ncol)
    deallocate(WORK)
    deallocate(x_tmp)

  end subroutine solveLinearSystemQR
  
end module linearSystemMod
