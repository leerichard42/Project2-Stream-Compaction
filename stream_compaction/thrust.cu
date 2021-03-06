#include <cuda.h>
#include <cuda_runtime.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/scan.h>
#include "common.h"
#include "thrust.h"

namespace StreamCompaction {
namespace Thrust {

/**
 * Performs prefix-sum (aka scan) on idata, storing the result into odata.
 */
float scan(int n, int *odata, const int *idata) {
    thrust::device_vector<int> dv_idata(idata, idata + n);
	thrust::device_vector<int> dv_odata(odata, odata + n);

	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	cudaEventRecord(start);
	thrust::exclusive_scan(dv_idata.begin(), dv_idata.end(), dv_odata.begin());	
	cudaEventRecord(stop);
	cudaEventSynchronize(stop);
	float milliseconds = 0;
	cudaEventElapsedTime(&milliseconds, start, stop);

	thrust::copy(dv_odata.begin(), dv_odata.end(), odata);

	return milliseconds;
}

}
}
