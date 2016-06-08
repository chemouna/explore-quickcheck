module Paths_explore_quickcheck (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/m.cheikhna/Documents/repos/mine/explore-quickcheck/.stack-work/install/x86_64-osx/lts-6.2/7.10.3/bin"
libdir     = "/Users/m.cheikhna/Documents/repos/mine/explore-quickcheck/.stack-work/install/x86_64-osx/lts-6.2/7.10.3/lib/x86_64-osx-ghc-7.10.3/explore-quickcheck-0.1.0.0-DIhLA8CwG3fJ876AahgATr"
datadir    = "/Users/m.cheikhna/Documents/repos/mine/explore-quickcheck/.stack-work/install/x86_64-osx/lts-6.2/7.10.3/share/x86_64-osx-ghc-7.10.3/explore-quickcheck-0.1.0.0"
libexecdir = "/Users/m.cheikhna/Documents/repos/mine/explore-quickcheck/.stack-work/install/x86_64-osx/lts-6.2/7.10.3/libexec"
sysconfdir = "/Users/m.cheikhna/Documents/repos/mine/explore-quickcheck/.stack-work/install/x86_64-osx/lts-6.2/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "explore_quickcheck_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "explore_quickcheck_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "explore_quickcheck_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "explore_quickcheck_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "explore_quickcheck_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
