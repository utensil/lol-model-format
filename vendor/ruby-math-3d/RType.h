#ifndef RTYPE_H_INCLUDED
#define RTYPE_H_INCLUDED

/*
 * Build Configuration
 *
 * * RMATH_SINGLE_PRECISION : float (32-bit single scalar)
 */
/*
#define RMATH_SINGLE_PRECISION
*/


#if defined(RMATH_SINGLE_PRECISION)
typedef float  rmReal;
#else
typedef double rmReal;
#endif

#if defined(RMATH_SINGLE_PRECISION)
# define RMATH_TOLERANCE (1e-6)
#else
# define RMATH_TOLERANCE (1e-15)
#endif

#if defined(RMATH_SINGLE_PRECISION)

#define rmAcos  acosf
#define rmAsin  asinf
#define rmAtan  atanf
#define rmAtan2 atan2f
#define rmCos   cosf
#define rmSin   sinf
#define rmTan   tanf
#define rmSqrt  sqrtf
#define rmFabs  fabsf

#else

#define rmAcos  acos
#define rmAsin  asin
#define rmAtan  atan
#define rmAtan2 atan2
#define rmCos   cos
#define rmSin   sin
#define rmTan   tan
#define rmSqrt  sqrt
#define rmFabs  fabs

#endif

#endif

/*
RMath : Ruby math module for 3D Applications
Copyright (c) 2008- vaiorabbit  <http://twitter.com/vaiorabbit>

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
 */
