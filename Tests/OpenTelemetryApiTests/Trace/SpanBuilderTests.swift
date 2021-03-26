// Copyright 2020, OpenTelemetry Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

@testable import OpenTelemetryApi
import XCTest

fileprivate func createRandomPropagatedSpan() -> PropagatedSpan {
    return PropagatedSpan(context: SpanContext.create(traceId: TraceId.random(),
                                                      spanId: SpanId.random(),
                                                      traceFlags: TraceFlags(),
                                                      traceState: TraceState()))
}

class SpanBuilderTests: XCTestCase {
    let tracer = DefaultTracer.instance

    func testDoNotCrash_NoopImplementation() {
        let spanBuilder = tracer.spanBuilder(spanName: "MySpanName")
        spanBuilder.setSpanKind(spanKind: .server)
        spanBuilder.setParent(createRandomPropagatedSpan())
        spanBuilder.setParent(createRandomPropagatedSpan().context)
        spanBuilder.setNoParent()
        spanBuilder.addLink(spanContext: createRandomPropagatedSpan().context)
        spanBuilder.addLink(spanContext: createRandomPropagatedSpan().context, attributes: [String: AttributeValue]())
        spanBuilder.addLink(spanContext: createRandomPropagatedSpan().context, attributes: [String: AttributeValue]())
        spanBuilder.setAttribute(key: "key", value: "value")
        spanBuilder.setAttribute(key: "key", value: 12345)
        spanBuilder.setAttribute(key: "key", value: 0.12345)
        spanBuilder.setAttribute(key: "key", value: true)
        spanBuilder.setAttribute(key: "key", value: AttributeValue.string("value"))
        spanBuilder.setStartTime(time: Date())
        XCTAssert(spanBuilder.startSpan() is PropagatedSpan)
    }
}
