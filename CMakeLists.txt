cmake_minimum_required(VERSION 3.16)

project(roameow)

find_package(ECM 1.4.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH})

find_package(Plasma REQUIRED)

plasma_install_package(package xyz.attacktive.nyan-wanderer)
