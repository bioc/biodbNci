test.nci.cactus.convCasToInchi <- function(conn) {
    
    cas2inchi <-
        c('557795-19-4'=paste0(
'InChI=1/C22H27FN4O2/c1-5-27(6-2)10-9-24-22(29)20-13(3)19(25-14(20)4)12-17',
'-16-11-15(23)7-8-18(16)26-21(17)28/h7-8,11-12,25H,5-6,9-10H2,1-4H3,(H,24,2',
'9)(H,26,28)/b17-12-/f/h24,26H'),
          '557795-1-4'=NA_character_,
          '75-07-0'='InChI=1/C2H4O/c1-2-3/h2H,1H3')
 
    inchi <- conn$convCasToInchi(names(cas2inchi))
    testthat::expect_is(inchi, 'character')
    testthat::expect_identical(inchi, unname(cas2inchi))
}

test.nci.cactus.convCasToInchikey <- function(conn) {
    
    cas2inchikey <- c('557795-19-4'='WINHZLLDWRZWRT-IUQVRHKZNA-N',
                      '75-07-0'='IKHGUXGNUITLKF-UHFFFAOYNA-N',
                      '557795-1-4'=NA_character_)

    inchikey <- conn$convCasToInchikey(names(cas2inchikey))
    testthat::expect_is(inchikey, 'character')
    testthat::expect_identical(inchikey, unname(cas2inchikey))
    
    # Check that passing factors work too
    inchikey <- conn$convCasToInchikey(as.factor(names(cas2inchikey)))
    testthat::expect_is(inchikey, 'character')
    testthat::expect_identical(inchikey, unname(cas2inchikey))
}

# Set test context
biodb::testContext("Tests of conversion functions")

source('gz_builder.R')

# Instantiate Biodb
biodb <- biodb::createBiodbTestInstance(ack=TRUE)

# Load package definitions
defFile <- system.file("definitions.yml", package='biodbNci')
biodb$loadDefinitions(defFile)

# Create connector
conn <- biodb$getFactory()$createConn('nci.cactus')
conn$setPropValSlot('urls', 'db.gz.url', two_entries_gz_file)

# Run tests
biodb::testThat('convCasToInchi() works fine.',
          test.nci.cactus.convCasToInchi, conn=conn)
biodb::testThat('convCasToInchikey() works fine.',
          test.nci.cactus.convCasToInchikey, conn=conn)

# Terminate Biodb
biodb$terminate()
