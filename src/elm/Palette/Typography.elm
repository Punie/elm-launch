module Palette.Typography exposing
    ( code
    , content
    , large
    , medium
    , meta
    , small
    , xlarge
    , xsmall
    , xxlarge
    )

import Element exposing (Attribute)
import Element.Font as Font exposing (Font, monospace, sansSerif)



-- FONTS


content : Attribute msg
content =
    Font.family
        [ roboto
        , sansSerif
        ]


meta : Attribute msg
meta =
    Font.family
        [ lato
        , sansSerif
        ]


code : Attribute msg
code =
    Font.family
        [ fira
        , monospace
        ]



-- FONT SIZES


xsmall : Attribute msg
xsmall =
    Font.size 8


small : Attribute msg
small =
    Font.size 12


medium : Attribute msg
medium =
    Font.size 16


large : Attribute msg
large =
    Font.size 24


xlarge : Attribute msg
xlarge =
    Font.size 32


xxlarge : Attribute msg
xxlarge =
    Font.size 36



-- FONT FACES


roboto : Font
roboto =
    Font.typeface "Roboto"


lato : Font
lato =
    Font.typeface "Lato"


fira : Font
fira =
    Font.typeface "Fira Code"
