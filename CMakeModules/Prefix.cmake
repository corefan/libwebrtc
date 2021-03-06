#
# Generate environment variables
#
set(WEBRTC_PATH ${CMAKE_SOURCE_DIR}/depot_tools)

if (WIN32)
  get_filename_component(DEPOT_TOOLS_PYTHON_PATH
                         "${WEBRTC_PATH}/python276_bin"
                         REALPATH)
  list(APPEND WEBRTC_PATH ${DEPOT_TOOLS_PYTHON_PATH})
endif (WIN32)

list(APPEND WEBRTC_PATH $ENV{PATH})

if (WIN32)
  string(REGEX REPLACE "/" "\\\\" WEBRTC_PATH "${WEBRTC_PATH}")
  string(REGEX REPLACE ";" "\\\;" WEBRTC_PATH "${WEBRTC_PATH}")
else (WIN32)
  string(REGEX REPLACE ";" ":" WEBRTC_PATH "${WEBRTC_PATH}")
endif (WIN32)

get_filename_component(CHROMIUM_PYTHONPATH
                       "${CMAKE_BINARY_DIR}/src/build"
                       REALPATH)

if (WIN32)
  set(PREFIX_FILENAME ${CMAKE_BINARY_DIR}/prefix.bat)
  set(PREFIX_COMMAND set)
  set(PREFIX_HEADER "@ECHO OFF")
  set(PREFIX_EVAL "%*")
  set(PREFIX_EXECUTE cmd /c ${PREFIX_FILENAME})
  set(PREFIX_NEWLINE \r\n)
else (WIN32)
  set(PREFIX_FILENAME ${CMAKE_BINARY_DIR}/prefix.sh)
  set(PREFIX_COMMAND export)
  set(PREFIX_HEADER "")
  set(PREFIX_EVAL eval\ $@)
  set(PREFIX_EXECUTE /bin/sh ${PREFIX_FILENAME})
  set(PREFIX_NEWLINE \n)
endif (WIN32)

file(WRITE ${PREFIX_FILENAME} "${PREFIX_HEADER}
${PREFIX_COMMAND} PATH=${WEBRTC_PATH}
${PREFIX_COMMAND} PYTHONPATH=${CHROMIUM_PYTHONPATH}
${PREFIX_COMMAND} DEPOT_TOOLS_WIN_TOOLCHAIN=0
${PREFIX_COMMAND} DEPOT_TOOLS_UPDATE=0
${PREFIX_COMMAND} CHROME_HEADLESS=1
${PREFIX_EVAL}
")
