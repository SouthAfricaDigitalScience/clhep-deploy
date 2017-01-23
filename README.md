[![Build Status](http://ci.sagrid.ac.za/buildStatus/icon?job=clhep-deploy)](http://ci.sagrid.ac.za/job/clhep-deploy)

# clhep-deploy

Build scripts and tests for the [CLHEP library](https://proj-clhep.web.cern.ch/proj-clhep/) for CODE-RADE

# Dependencies

This project depends on

  * cmake

# Versions

We build the following versions :

  * 2.3.2.2
  * 2.3.1.1
  * 2.3.4.3

# Configuration

The builds are configured out-of-source with cmake :

```
cmake -G"Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${SOFT_DIR}
```

# Citing
