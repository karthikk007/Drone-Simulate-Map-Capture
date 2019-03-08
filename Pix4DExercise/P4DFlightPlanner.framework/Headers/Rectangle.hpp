// (c) Pix4D. AUTOGENERATED FILE. DO NOT MODIFY.
#pragma once

#include "Coordinate2D.hpp"
#include "Size.hpp"

namespace px4d {

struct Rectangle final {
    Coordinate2D center;
    Size size;
    double rotation;

    Rectangle() = default;

    Rectangle(Coordinate2D center_,
              Size size_,
              double rotation_)
    : center(std::move(center_))
    , size(std::move(size_))
    , rotation(std::move(rotation_))
    {}
};

}  // namespace px4d
