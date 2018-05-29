{-# LANGUAGE DeriveGeneric, DeriveDataTypeable, DeriveFunctor, GeneralizedNewtypeDeriving, DeriveFoldable, DeriveTraversable #-}
module NumHask.Data.Complex where

import GHC.Generics (Generic, Generic1)
import Data.Data (Data)

import NumHask.Algebra.Additive
import NumHask.Algebra.Multiplicative
import NumHask.Algebra.Ring
import NumHask.Algebra.Distribution

import Prelude hiding (Num(..), negate, sin, cos)

-- -----------------------------------------------------------------------------
-- The Complex type

infix  6  :+

-- | Complex numbers are an algebraic type.
--
-- For a complex number @z@, @'abs' z@ is a number with the magnitude of @z@,
-- but oriented in the positive real direction, whereas @'signum' z@
-- has the phase of @z@, but unit magnitude.
--
-- The 'Foldable' and 'Traversable' instances traverse the real part first.
data Complex a
  = !a :+ !a    -- ^ forms a complex number from its real and imaginary
                -- rectangular components.
        deriving (Eq, Show, Read, Data, Generic, Generic1
                , Functor, Foldable, Traversable)

-- | Extracts the real part of a complex number.
realPart :: Complex a -> a
realPart (x :+ _) =  x

-- | Extracts the imaginary part of a complex number.
imagPart :: Complex a -> a
imagPart (_ :+ y) =  y








instance (AdditiveMagma a) => AdditiveMagma (Complex a) where
  (rx :+ ix) `plus` (ry :+ iy) = (rx `plus` ry) :+ (ix `plus` iy)

instance (AdditiveUnital a) => AdditiveUnital (Complex a) where
  zero = zero :+ zero  

instance (AdditiveAssociative a) => AdditiveAssociative (Complex a)

instance (AdditiveCommutative a) => AdditiveCommutative (Complex a)

instance (Additive a) => Additive (Complex a)

instance (AdditiveInvertible a) => AdditiveInvertible (Complex a) where
  negate (rx :+ ix) = negate rx :+ negate ix

instance (AdditiveGroup a) => AdditiveGroup (Complex a)


instance (Distribution a, AdditiveGroup a) => Distribution (Complex a)


instance (AdditiveUnital a, AdditiveGroup a, MultiplicativeUnital a) => MultiplicativeUnital (Complex a) where
  one = one :+ zero

instance (MultiplicativeMagma a, AdditiveGroup a) => MultiplicativeMagma (Complex a) where
  (rx :+ ix) `times` (ry :+ iy) =
    (rx `times` ry - ix `times` iy) :+ (ix `times` ry + iy `times` rx)




instance (AdditiveGroup a, MultiplicativeAssociative a) =>
         MultiplicativeAssociative (Complex a)


instance (Semiring a, AdditiveGroup a) => Semiring (Complex a)

instance (Semiring a, AdditiveGroup a) => InvolutiveRing (Complex a)






-- * Helpers from Data.Complex 



-- mkPolar r theta  =  r * cos theta :+ r * sin theta


-- -- | @'cis' t@ is a complex value with magnitude @1@
-- -- and phase @t@ (modulo @2*'pi'@).
-- {-# SPECIALISE cis :: Double -> Complex Double #-}
-- cis              :: Floating a => a -> Complex a
-- cis theta        =  cos theta :+ sin theta

-- -- | The function 'polar' takes a complex number and
-- -- returns a (magnitude, phase) pair in canonical form:
-- -- the magnitude is nonnegative, and the phase in the range @(-'pi', 'pi']@;
-- -- if the magnitude is zero, then so is the phase.
-- {-# SPECIALISE polar :: Complex Double -> (Double,Double) #-}
-- polar            :: (RealFloat a) => Complex a -> (a,a)
-- polar z          =  (magnitude z, phase z)

-- -- | The nonnegative magnitude of a complex number.
-- {-# SPECIALISE magnitude :: Complex Double -> Double #-}
-- magnitude :: (RealFloat a) => Complex a -> a
-- magnitude (x:+y) =  scaleFloat k
--                      (sqrt (sqr (scaleFloat mk x) + sqr (scaleFloat mk y)))
--                     where k  = max (exponent x) (exponent y)
--                           mk = - k
--                           sqr z = z * z

-- -- | The phase of a complex number, in the range @(-'pi', 'pi']@.
-- -- If the magnitude is zero, then so is the phase.
-- {-# SPECIALISE phase :: Complex Double -> Double #-}
-- phase :: (RealFloat a) => Complex a -> a
-- phase (0 :+ 0)   = 0            -- SLPJ July 97 from John Peterson
-- phase (x:+y)     = atan2 y xa