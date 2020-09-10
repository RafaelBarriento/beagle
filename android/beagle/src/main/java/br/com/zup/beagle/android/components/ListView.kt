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
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import br.com.zup.beagle.android.action.Action
import br.com.zup.beagle.android.action.OnInitFinishedListener
import br.com.zup.beagle.android.action.OnInitiableComponent
import br.com.zup.beagle.android.context.Bind
import br.com.zup.beagle.android.context.ContextComponent
import br.com.zup.beagle.android.context.ContextData
import br.com.zup.beagle.android.view.ViewFactory
import br.com.zup.beagle.android.widget.RootView
import br.com.zup.beagle.annotation.RegisterWidget
import br.com.zup.beagle.core.ServerDrivenComponent
import br.com.zup.beagle.widget.core.ListDirection

@RegisterWidget
data class ListViewOriginal(
    val children: List<ServerDrivenComponent>? = null,
    override val context: ContextData? = null,
    override val onInit: List<Action>? = null,
    val dataSource: Bind<List<Any>>? = null,
    val direction: ListDirection,
    val template: ServerDrivenComponent? = null,
    val onScrollEnd: List<Action>? = null,
    val scrollThreshold: Int? = null,
    val useParentScroll: Boolean = false
) : OnInitiableComponent(), ContextComponent {

    @Transient
    private val viewFactory: ViewFactory = ViewFactory()

    override fun buildView(rootView: RootView): View {

        if (children.isNullOrEmpty()) {
            template?.let {
                dataSource?.let {
                    return ListView(
                        context,
                        onInit,
                        dataSource,
                        direction,
                        template,
                        onScrollEnd,
                        scrollThreshold
                    ).buildView(rootView)
                }
            }
        }

        val recyclerView = viewFactory.makeRecyclerView(rootView.getContext())
        /*recyclerView.apply {
            val orientation = toRecyclerViewOrientation()
            layoutManager = LinearLayoutManager(context, orientation, false)
            adapter = ListViewRecyclerAdapter(children, viewFactory, orientation, rootView)
        }*/

        return recyclerView
    }

    private fun toRecyclerViewOrientation() = if (direction == ListDirection.VERTICAL) {
        RecyclerView.VERTICAL
    } else {
        RecyclerView.HORIZONTAL
    }

    override fun executeOnInit(rootView: RootView, listener: OnInitFinishedListener?) {
        TODO("Not yet implemented")
    }

//    override fun executeOnInit(rootView: RootView, listener: OnInitFinishedListener?) {
//        TODO("Not yet implemented")
//    }
//
//    override fun addOnInitFinishedListener(listener: OnInitFinishedListener) {
//        TODO("Not yet implemented")
//    }

}

internal class ListViewRecyclerAdapter(
    private val children: List<ServerDrivenComponent>,
    private val viewFactory: ViewFactory,
    private val orientation: Int,
    private val rootView: RootView
) : RecyclerView.Adapter<ViewHolder>() {

    override fun getItemViewType(position: Int): Int = position

    override fun onCreateViewHolder(parent: ViewGroup, position: Int): ViewHolder {
        val view = viewFactory.makeBeagleFlexView(rootView).also {
            val width = if (orientation == RecyclerView.VERTICAL)
                ViewGroup.LayoutParams.MATCH_PARENT else
                ViewGroup.LayoutParams.WRAP_CONTENT
            val layoutParams = ViewGroup.LayoutParams(width, ViewGroup.LayoutParams.WRAP_CONTENT)
            it.layoutParams = layoutParams
            it.addServerDrivenComponent(children[position])
        }
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

    }

    override fun getItemCount(): Int = children.size
}

internal class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView)
