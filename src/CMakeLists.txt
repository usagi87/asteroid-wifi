add_library(${CMAKE_PROJECT_NAME} main.cpp resources.qrc)

target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC
	AsteroidApp)

install(TARGETS ${CMAKE_PROJECT_NAME}
	DESTINATION ${CMAKE_INSTALL_LIBDIR})