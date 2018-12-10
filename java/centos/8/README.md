# adorsys/java:8

Empfohlene JVM Einstellungen für Kubernetes based runtimes

https://docs.openshift.com/container-platform/3.10/dev_guide/application_memory_sizing.html

https://developers.redhat.com/blog/2017/04/04/openjdk-and-containers/


```bash
-XshowSettings:vm -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap \
  -Dsun.zip.disableMemoryMapping=true -XX:MaxRAMFraction=1 -XX:+UseParallelGC \
  -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10 -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90  
```


| Parameter | Explanation |
|-----------|-------------|
| -XshowSettings:vm | Show calculated heap space on startup.
| -XX:+UnlockExperimentalVMOptions | Allow experimental parameters
| -XX:+UseCGroupMemoryLimitForHeap | This sets -XX:MaxRAM to the container memory limit, and the maximum heap size (-XX:MaxHeapSize / -Xmx) to 1/-XX:MaxRAMFraction
| -Dsun.zip.disableMemoryMapping=true | Disable memory mapping of jar files which reduces VmRSS some more. The added (performance) cost for class loading is negligible.
| -XX:MaxRAMFraction=1 | -XX:MaxRAM * 1/-XX:MaxRAMFraction = -Xmx . 1 means use all available memory for JVM
| -XX:+UseParallelGC | Default GC in JVM und braucht nicht zwingend gesetzt werden.
| -XX:MinHeapFreeRatio=5 <br>-XX:MaxHeapFreeRatio=10| These parameters tell the heap to shrink aggressively and to grow conservatively. Thereby optimizing the amount of memory available to the operating system.
| -XX:GCTimeRatio=4 | GCTimeRatio specifies the worst case GC time the collector should target. A value of 99 means no more than 1% of time should be spent in GC. In practice, that means that the parallel GC has to play cautious. So, it regularly trades off space for time even when the actual GC time is a tiny fraction of 1%.
| -XX:AdaptiveSizePolicyWeight=90 | The AdaptiveSizePolicyWeight parameter controls how much previous GC times are taken into account when checking the timing goal. The default setting, 10, bases the timing goal check 90% on previous GC times and 10% on the current GC time. Resetting this to 90 means that the timing goal check is mostly based on to the current GC execution time, i.e. it is more responsive to current rather than historical memory use. This greater responsiveness also usefully limits the extent to which space gets traded off against time.