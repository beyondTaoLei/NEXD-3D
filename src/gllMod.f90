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
module gllMod
	use constantsMod
! module to generate gll points
  implicit none

contains

  function getGll()
    ! INPUT: Nothing
    ! DOES: Calculates Gauss-Lobatto-Legendre (GLL) nodes with Newton Raphson iteration
    ! RETURNS: gll points
    real(kind=CUSTOM_REAL), dimension(NGLL) :: x,GetGll
    real(kind=CUSTOM_REAL), dimension(NGLL,NGLL):: V
    real(kind=CUSTOM_REAL) :: xold
    integer :: i,k,p

    p = NGLL-1

    do i=1,NGLL
        x(i) = cos(pi*(i-1)/p)
    end do

! Newton-Raphson iteration
    do i=1,NGLL
        xold = 2.
        do while (abs(x(i)-xold) > eps)
            xold = x(i)
            V(i,1) = 1.
            V(i,2) = x(i)
            do k=2,p
                V(i,k+1) = ((2.*k-1.)*x(i)*V(i,k)-(k-1.)*V(i,k-1))/k
            end do
            x(i) = xold-(x(i)*V(i,NGLL)-V(i,p))/(NGLL*V(i,NGLL))
        end do
    end do
    GetGLL=x
  end function getGll

end module gllMod
