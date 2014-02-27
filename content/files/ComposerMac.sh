#!/bin/sh

export XAK_HOME=/Users/Onekin/Desktop/Firefox_AddOn_Dev/extensions/scxmlGitDelta/xak
export XAK_JAR=${XAK_HOME}/lib/xak.jar
export CLASSPATH=${CLASSPATH}:${XAK_HOME}/lib/log4j.jar:${XAK_HOME}/lib/onekin.jar:${XAK_HOME}/lib/saxon8.jar:${XAK_HOME}/lib/saxon8-xapth.jar


export PROJECT_HOME=/Users/Onekin/Desktop/Firefox_AddOn_Dev/extensions/scxmlGitDelta/content/files

#comentario
echo "Welcome to cowpath delta :) !"
echo "1. Obtaining base file URL from Delta file"
#-------------------------------------------------------
#1. Extraer del fichero del delta la URL del cowpath base
#-------------------------------------------------------
#Crear un fichero con la URL del cowpath base

#java net.sf.saxon.Transform -o ${PROJECT_HOME}/autoannotation_process/URL_file.txt  ${PROJECT_HOME}/user_files/delta.xml  ${PROJECT_HOME}/autoannotation_process/extract_core_URL.xsl

#Variable con la URL del cowpath base
#URL=$(<${PROJECT_HOME}/autoannotation_process/URL_file.txt)

echo "2. Download cowpath base from: $URL"
#-------------------------------------------------------
#2. Bajar el fichero de la URL del delta.xml, atributo core
#-------------------------------------------------------
#wget -O ${PROJECT_HOME}/download/cowpath_base.xml "$URL"

echo "3. Autoannotating base file"
#-------------------------------------------------------
#3. Autoanotar el fichero base del usuario  para XAK
#-------------------------------------------------------
java net.sf.saxon.Transform -o ${PROJECT_HOME}/base_annotated.xml  ${PROJECT_HOME}/base.xml  ${PROJECT_HOME}/scxml2xak.xsl

echo "4. Transforming delta into XAK"
#--------------------------------------------------------
#4. Transformar el delta del usuario a XAK
#--------------------------------------------------------
java net.sf.saxon.Transform -o ${PROJECT_HOME}/refinement.xml  ${PROJECT_HOME}/delta.xml  ${PROJECT_HOME}/deltaScxml2_to_xak.xsl

echo "5. Composing base and delta"
#----------------------------------------------------------
#5. Componer refinement con el base autoannotado
#----------------------------------------------------------
cp ${PROJECT_HOME}/base_annotated.xml  ${PROJECT_HOME}/base_annotated.xak
cp ${PROJECT_HOME}/refinement.xml ${PROJECT_HOME}/refinement.xak
java -jar ${XAK_JAR}  -c ${PROJECT_HOME}/base_annotated.xak ${PROJECT_HOME}/refinement.xak -o ${PROJECT_HOME}/result.xak

#----------------------------------------------------------
#6. Ir a webaugmentation con el contenido del script nuevo
#----------------------------------------------------------
##URL2=$(cat /Users/Onekin/Desktop/Transclusion_for_cowpath/pruebas/result.xml | openssl base64 | tr -d '\n')
#open -a Firefox "http://webaugmentation.org/cowpath/?CONTENT=$URL2"

echo "END. The new cowapth is created in: ${PROJECT_HOME}/user_files/result.xml"
