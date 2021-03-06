! Copyright (c) 2019, NVIDIA CORPORATION.  All rights reserved.
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.

! Test 15.5.2.7 constraints and restrictions for POINTER dummy arguments.

module m
 contains

  subroutine s01(p)
    real, pointer, contiguous, intent(in) :: p(:)
  end subroutine
  subroutine s02(p)
    real, pointer :: p(:)
  end subroutine
  subroutine s03(p)
    real, pointer, intent(in) :: p(:)
  end subroutine

  subroutine test
    !ERROR: CONTIGUOUS pointer must be an array
    real, pointer, contiguous :: a01 ! C830
    real, pointer :: a02(:)
    real, target :: a03(10)
    real :: a04(10) ! not TARGET
    call s01(a03) ! ok
    !ERROR: Effective argument associated with CONTIGUOUS POINTER dummy argument must be simply contiguous
    call s01(a02)
    !ERROR: Effective argument associated with CONTIGUOUS POINTER dummy argument must be simply contiguous
    call s01(a03(::2))
    !ERROR: Effective argument associated with CONTIGUOUS POINTER dummy argument must be simply contiguous
    call s01(a03([1,2,4]))
    call s02(a02) ! ok
    call s03(a03) ! ok
    !ERROR: Effective argument associated with POINTER dummy argument must be POINTER unless INTENT(IN)
    call s02(a03)
    !ERROR: Effective argument associated with POINTER INTENT(IN) dummy argument must be a valid target if not a POINTER
    call s03(a03([1,2,4]))
    !ERROR: Effective argument associated with POINTER INTENT(IN) dummy argument must be a valid target if not a POINTER
    call s03([1.])
    !ERROR: Effective argument associated with POINTER INTENT(IN) dummy argument must be a valid target if not a POINTER
    call s03(a04)
  end subroutine
end module
