datacache <- new.env(hash=TRUE, parent=emptyenv())

org.Hbacteriophora.eg <- function() showQCData("org.Hbacteriophora.eg", datacache)
org.Hbacteriophora.eg_dbconn <- function() dbconn(datacache)
org.Hbacteriophora.eg_dbfile <- function() dbfile(datacache)
org.Hbacteriophora.eg_dbschema <- function(file="", show.indices=FALSE) dbschema(datacache, file=file, show.indices=show.indices)
org.Hbacteriophora.eg_dbInfo <- function() dbInfo(datacache)

org.Hbacteriophora.egORGANISM <- "Heterorhabditis bacteriophora"

.onLoad <- function(libname, pkgname) {
    ## Load AnnotationHub
    hub <- AnnotationHub:::AnnotationHub()

    ## Query for the specific database (organism & sqlite)
    query_result <- AnnotationHub:::query(hub, c("Heterorhabditis", "bacteriophora", "sqlite"))

    ## Assuming the SQLite file is the first query result
    sqliteFile <- query_result[[1]]

    ## Assign the database file path and connection
    dbfile <- sqliteFile$path
    assign("dbfile", dbfile, envir=datacache)
    dbconn <- dbFileConnect(dbfile)
    assign("dbconn", dbconn, envir=datacache)

    ## Create the OrgDb object from the AnnotationHub resource
    sPkgname <- sub(".db$", "", pkgname)
    db <- loadDb(dbfile, packageName = pkgname)
    dbNewname <- AnnotationDbi:::dbObjectName(pkgname, "OrgDb")
    ns <- asNamespace(pkgname)
    assign(dbNewname, db, envir=ns)
    namespaceExport(ns, dbNewname)

    packageStartupMessage(AnnotationDbi:::annoStartupMessages("org.Hbacteriophora.eg.db"))
}

.onUnload <- function(libpath) {
    dbFileDisconnect(org.Hbacteriophora.eg_dbconn())
}
