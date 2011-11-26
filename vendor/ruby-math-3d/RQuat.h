/* -*- C -*- */
#ifndef RMATHQUAT_H_INCLUDED
#define RMATHQUAT_H_INCLUDED

#include "RType.h"

struct RVec3;
struct RMtx4;

typedef struct RQuat
{
    union
    {
        struct
        {
            rmReal x, y, z, w;
        };
        rmReal e[4];
    };
} RQuat;

#ifdef __cplusplus
extern "C" {
#endif

void    RQuatSetElements( RQuat* out, rmReal x, rmReal y, rmReal z, rmReal w );
void    RQuatSetElement( RQuat* out, int at, rmReal f );
void    RQuatSetX( RQuat* out, rmReal x );
void    RQuatSetY( RQuat* out, rmReal y );
void    RQuatSetZ( RQuat* out, rmReal z );
void    RQuatSetW( RQuat* out, rmReal w );
void    RQuatSetXYZ( RQuat* out, const struct RVec3* v );

rmReal  RQuatGetElement( const RQuat* in, int at );
rmReal  RQuatGetX( const RQuat* in );
rmReal  RQuatGetY( const RQuat* in );
rmReal  RQuatGetZ( const RQuat* in );
rmReal  RQuatGetW( const RQuat* in );
void    RQuatGetXYZ( struct RVec3* out, const RQuat* in );

int     RQuatEqual( const RQuat* q1, const RQuat* q2 );
rmReal  RQuatDot( const RQuat* q1, const RQuat* q2 );

void    RQuatIdentity( RQuat* out );
void    RQuatCopy( RQuat* out, const RQuat* in );
void    RQuatNormalize( RQuat* out, const RQuat* in );
void    RQuatConjugate( RQuat* out, const RQuat* in );
void    RQuatInverse( RQuat* out, const RQuat* in );

void    RQuatAdd( RQuat* out, const RQuat* q1, const RQuat* q2 );
void    RQuatSub( RQuat* out, const RQuat* q1, const RQuat* q2 );
void    RQuatMul( RQuat* out, const RQuat* q1, const RQuat* q2 );
void    RQuatScale( RQuat* out, const RQuat* in, rmReal f );

rmReal  RQuatLength( const RQuat* in );
rmReal  RQuatLengthSq( const RQuat* in );

void    RQuatSlerp( RQuat* out, const RQuat* q1, const RQuat* q2, rmReal t );

void    RQuatRotationMatrix( RQuat* out, const struct RMtx4* mtx );
void    RQuatRotationAxis( RQuat* out, const struct RVec3* axis, rmReal radian );
void    RQuatToAxisAngle( const RQuat* in, struct RVec3* axis, rmReal* radian );

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
