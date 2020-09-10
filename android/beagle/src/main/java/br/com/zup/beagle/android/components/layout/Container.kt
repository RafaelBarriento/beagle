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

package br.com.zup.beagle.android.components.layout

import android.view.View
import br.com.zup.beagle.android.action.Action
import br.com.zup.beagle.android.action.OnActionFinished
import br.com.zup.beagle.android.action.OnInitFinishedListener
import br.com.zup.beagle.android.action.OnInitiableComponent
import br.com.zup.beagle.android.context.ContextComponent
import br.com.zup.beagle.android.context.ContextData
import br.com.zup.beagle.android.view.ViewFactory
import br.com.zup.beagle.android.view.custom.BeagleFlexView
import br.com.zup.beagle.android.widget.RootView
import br.com.zup.beagle.annotation.RegisterWidget
import br.com.zup.beagle.core.MultiChildComponent
import br.com.zup.beagle.core.ServerDrivenComponent
import br.com.zup.beagle.core.Style

@RegisterWidget
data class Container(
    override val children: List<ServerDrivenComponent>,
    override val context: ContextData? = null,
    override val onInit: List<Action>? = null
) : OnInitiableComponent(), ContextComponent, MultiChildComponent {

    @Transient
    private val viewFactory = ViewFactory()

    @Transient
    private var onInitDone = false

    @Transient
    private lateinit var view: BeagleFlexView

    override fun buildView(rootView: RootView): View {
        view = viewFactory.makeBeagleFlexView(rootView, style ?: Style())

        var onInitCalled = false
        view.addOnAttachStateChangeListener(object : View.OnAttachStateChangeListener {
            override fun onViewAttachedToWindow(v: View?) {
                if (v == view) {
                    if (!onInitCalled) {
                        executeOnInit(rootView, onInitFinishedListener)
                        onInitCalled = true
                    }
                }
            }
            override fun onViewDetachedFromWindow(v: View?) {}
        })

        return view.apply {
            addChildren(this)
        }
    }

    private fun addChildren(beagleFlexView: BeagleFlexView) {
        children.forEach { child ->
            beagleFlexView.addServerDrivenComponent(child)
        }
    }

    override fun executeOnInit(rootView: RootView, listener: OnInitFinishedListener?) {
        val onInitActions = onInit?.toMutableList()
        onInit?.forEach { action ->
            action.execute(rootView, view, object : OnActionFinished {
                override fun onActionFinished(action: Action) {
                    onInitActions?.remove(action)
                    if (onInitActions?.isEmpty() == true) {
                        onInitDone = true
                        listener?.invoke(this@Container)
                    }
                }
            })
        }
    }
}
