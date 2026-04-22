import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/ambience_cubit.dart';
import '../cubit/ambience_state.dart';
import '../widgets/ambience_card.dart';
import '../../journal/cubit/journal_cubit.dart';
import '../../journal/screens/history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AmbienceCubit>();

    final tags = ["Focus", "Calm", "Sleep", "Reset"];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12),
      body: SafeArea(
        child: BlocBuilder<AmbienceCubit, AmbienceState>(
          builder: (context, state) {
            if (state is AmbienceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AmbienceLoaded) {
              final list = state.filtered;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ===== Header =====
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Explore Ambiences",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.history, color: Colors.white),
                          onPressed: () {
                            final journalCubit = context.read<JournalCubit>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: journalCubit,
                                  child: const HistoryScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // ===== Search Bar =====
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: TextField(
                      onChanged: cubit.search,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle:
                            const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.search,
                            color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF1A1A28),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // ===== Tag Filter Chips =====
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      children: tags.map((tag) {
                        final isSelected = state.selectedTag == tag;
                        return GestureDetector(
                          onTap: () {
                            if (isSelected) {
                              cubit.clearFilters();
                            } else {
                              cubit.filterByTag(tag);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF7C6FFF)
                                  : const Color(0xFF1A1A28),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ===== Grid or Empty State =====
                  Expanded(
                    child: list.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "No ambiences found",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: cubit.clearFilters,
                                  child: const Text(
                                    "Clear Filters",
                                    style: TextStyle(
                                      color: Color(0xFF7C6FFF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.78,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return AmbienceCard(item: list[index]);
                            },
                          ),
                  ),
                ],
              );
            }

            return const SizedBox();
          }, 
        ),
      ),
    );
  }
}