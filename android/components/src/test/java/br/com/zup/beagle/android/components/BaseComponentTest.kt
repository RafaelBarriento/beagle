/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package br.com.zup.beagle.android.components

import android.view.View
import br.com.zup.beagle.android.designsystem.constant.DesignSystemConstant
import br.com.zup.beagle.android.utils.BaseTest
import br.com.zup.beagle.android.engine.renderer.ViewRenderer
import br.com.zup.beagle.android.engine.renderer.ViewRendererFactory
import br.com.zup.beagle.android.utils.beagleComponent
import br.com.zup.beagle.android.view.ComponentsViewFactory
import br.com.zup.beagle.android.view.custom.BeagleFlexView
import br.com.zup.beagle.android.widget.RootView
import br.com.zup.beagle.core.ServerDrivenComponent
import io.mockk.Runs
import io.mockk.every
import io.mockk.just
import io.mockk.mockk
import io.mockk.mockkConstructor

abstract class BaseComponentTest : BaseTest() {

    internal val viewRender: ViewRenderer<ServerDrivenComponent> = mockk()

    internal val beagleFlexView: BeagleFlexView = mockk(relaxed = true)

    val rootView: RootView = mockk(relaxed = true)

    val view: View = mockk(relaxed = true)

    override fun setUp() {
        super.setUp()

        mockkConstructor(ViewRendererFactory::class)
        mockkConstructor(ComponentsViewFactory::class)

        DesignSystemConstant.context = mockk(relaxed = true)

        every { anyConstructed<ViewRendererFactory>().make(any()) } returns viewRender
        every { anyConstructed<ComponentsViewFactory>().makeBeagleFlexView(any()) } returns beagleFlexView
        every { anyConstructed<ComponentsViewFactory>().makeBeagleFlexView(any(), any()) } returns beagleFlexView


        every { viewRender.build(any()) } returns view
        every { view.tag = any() } just Runs
    }
}