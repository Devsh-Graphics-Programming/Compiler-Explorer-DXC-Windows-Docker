if(NOT DEFINED OUTPUT_HLP_PATH)
	message(FATAL_ERROR "OUTPUT_HLP_PATH must be defined!")
endif()

string(APPEND IMPL_CONTENT
[=[
compilers=@COMPILERS@
]=]
)

message(STATUS "SERVER = ON")

foreach(SERVER IN LISTS SERVER_NAME)
	message(STATUS "SERVER_NAME = ${SERVER}")
	list(APPEND COMPILERS "${SERVER}@443")
endforeach()
string(REPLACE ";" ":" COMPILERS "${COMPILERS}")

message(STATUS "Creating \"${OUTPUT_HLP_PATH}\"")

file(WRITE "${OUTPUT_HLP_PATH}" "${IMPL_CONTENT}")
configure_file("${OUTPUT_HLP_PATH}" "${OUTPUT_HLP_PATH}")