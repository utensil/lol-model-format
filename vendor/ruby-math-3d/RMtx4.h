/* -*- C -*- */
#ifndef RMATHMTX4_H_INCLUDED
#define RMATHMTX4_H_INCLUDED

#include "RType.h"

struct RVec3;
struct RVec4;
struct RQuat;

typedef struct RMtx4
{
    union
    {
        /* NOTE : column-major */
        struct
        {
            rmReal e00, e10, e20, e30;
            rmReal e01, e11, e21, e31;
            rmReal e02, e12, e22, e32;
            rmReal e03, e13, e23, e33;
        };
        rmReal e[16];
    };
} RMtx4;

#ifdef __cplusplus
extern "C" {
#endif

void RMtx4SetElements( RMtx4* out,
                       rmReal e00, rmReal e01, rmReal e02, rmReal e03,
                       rmReal e10, rmReal e11, rmReal e12, rmReal e13,
                       rmReal e20, rmReal e21, rmReal e22, rmReal e23,
                       rmReal e30, rmReal e31, rmReal e32, rmReal e33
    );

void    RMtx4SetElement( RMtx4* out, int row, int col, rmReal e );
rmReal  RMtx4GetElement( const RMtx4* in, int row, int col );

void    RMtx4GetRow( struct RVec4* out, const RMtx4* in, int row );
void    RMtx4GetColumn( struct RVec4* out, const RMtx4* in, int col );

void    RMtx4SetRow( struct RMtx4* out, const struct RVec4* in, int row );
void    RMtx4SetColumn( struct RMtx4* out, const struct RVec4* in, int col );

void    RMtx4GetUpper3x3( struct RMtx3* out, const struct RMtx4* in );
void    RMtx4SetUpper3x3( struct RMtx4* out, const struct RMtx3* in );

void    RMtx4Copy( RMtx4* out, const RMtx4* in );

void    RMtx4Zero( RMtx4* out );
void    RMtx4Identity( RMtx4* out );
rmReal  RMtx4Determinant( const RMtx4* in );
void    RMtx4Transpose( RMtx4* out, const RMtx4* in );
rmReal  RMtx4Inverse( RMtx4* out, const RMtx4* in );

void    RMtx4Translation( RMtx4* out, rmReal tx, rmReal ty, rmReal tz );
void    RMtx4RotationX( RMtx4* out, rmReal radian );
void    RMtx4RotationY( RMtx4* out, rmReal radian );
void    RMtx4RotationZ( RMtx4* out, rmReal radian );
void    RMtx4RotationAxis( RMtx4* out, const struct RVec3* axis, rmReal radian );
void    RMtx4RotationQuaternion( RMtx4* out, const struct RQuat* q );
void    RMtx4Scaling( RMtx4* out, rmReal sx, rmReal sy, rmReal sz );

int     RMtx4Equal( const RMtx4* m1, const RMtx4* m2 );

void    RMtx4Add( RMtx4* out, const RMtx4* m1, const RMtx4* m2 );
void    RMtx4Sub( RMtx4* out, const RMtx4* m1, const RMtx4* m2 );
void    RMtx4Mul( RMtx4* out, const RMtx4* m1, const RMtx4* m2 );
void    RMtx4Scale( RMtx4* out, const RMtx4* m, rmReal f );

void    RMtx4LookAtRH( RMtx4* out, const struct RVec3* eye, const struct RVec3* at, const struct RVec3* up );
void    RMtx4PerspectiveRH( RMtx4* out, rmReal width, rmReal height, rmReal znear, rmReal zfar );
void    RMtx4PerspectiveFovRH( RMtx4* out, rmReal fovy_radian, rmReal aspect, rmReal znear, rmReal zfar );
void    RMtx4PerspectiveOffCenterRH( RMtx4* out, rmReal left, rmReal right, rmReal bottom, rmReal top, rmReal znear, rmReal zfar );
void    RMtx4OrthoRH( RMtx4* out, rmReal width, rmReal height, rmReal znear, rmReal zfar );
void    RMtx4OrthoOffCenterRH( RMtx4* out, rmReal left, rmReal right, rmReal bottom, rmReal top, rmReal znear, rmReal zfar );

#ifdef __cplusplus
}
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
