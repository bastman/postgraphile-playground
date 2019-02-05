#!/usr/bin/env bash

export DEBUG="postgraphile:graphql,postgraphile:request,postgraphile:postgres*"
echo ${DEBUG}
npx postgraphile -c postgres://postgres:postgres@localhost/app --enhance-graphiql --extended-errors severity,code,detail,hint,positon,internalPosition,internalQuery,where,schema,table,column,dataType,constraint,file,line,routine
