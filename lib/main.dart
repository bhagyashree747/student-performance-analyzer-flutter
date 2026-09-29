import 'package:flutter/material.dart';

void main() {
  runApp(const StudentPerformanceApp());
}

// ------------------------------------------------------------
// DATA MODEL
// ------------------------------------------------------------

class SubjectPerformance {
  String name;
  double marks;
  double attendance;

  SubjectPerformance({
    required this.name,
    required this.marks,
    required this.attendance,
  });

  String get grade {
    if (marks >= 90) return 'A+';
    if (marks >= 80) return 'A';
    if (marks >= 70) return 'B+';
    if (marks >= 60) return 'B';
    if (marks >= 50) return 'C';
    if (marks >= 40) return 'D';
    return 'F';
  }

  String get status {
    if (marks >= 75 && attendance >= 75) {
      return 'Excellent';
    }

    if (marks >= 60 && attendance >= 75) {
      return 'Good';
    }

    if (marks >= 50 && attendance >= 65) {
      return 'Average';
    }

    return 'Needs Attention';
  }
}

// ------------------------------------------------------------
// GLOBAL APP
// ------------------------------------------------------------

class StudentPerformanceApp extends StatefulWidget {
  const StudentPerformanceApp({super.key});

  @override
  State<StudentPerformanceApp> createState() => _StudentPerformanceAppState();
}

class _StudentPerformanceAppState extends State<StudentPerformanceApp> {
  bool isDarkMode = false;

  final List<SubjectPerformance> subjects = [
    SubjectPerformance(name: 'Machine Learning', marks: 88, attendance: 92),
    SubjectPerformance(name: 'Data Structures', marks: 76, attendance: 84),
    SubjectPerformance(name: 'Web Development', marks: 91, attendance: 88),
  ];

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void addSubject(SubjectPerformance subject) {
    setState(() {
      subjects.add(subject);
    });
  }

  void removeSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  double get averageMarks {
    if (subjects.isEmpty) return 0;

    double total = 0;

    for (final subject in subjects) {
      total += subject.marks;
    }

    return total / subjects.length;
  }

  double get averageAttendance {
    if (subjects.isEmpty) return 0;

    double total = 0;

    for (final subject in subjects) {
      total += subject.attendance;
    }

    return total / subjects.length;
  }

  String get overallGrade {
    if (averageMarks >= 90) return 'A+';
    if (averageMarks >= 80) return 'A';
    if (averageMarks >= 70) return 'B+';
    if (averageMarks >= 60) return 'B';
    if (averageMarks >= 50) return 'C';
    if (averageMarks >= 40) return 'D';
    return 'F';
  }

  String get overallStatus {
    if (averageMarks >= 75 && averageAttendance >= 75) {
      return 'Excellent';
    }

    if (averageMarks >= 60 && averageAttendance >= 75) {
      return 'Good';
    }

    if (averageMarks >= 50) {
      return 'Average';
    }

    return 'Needs Improvement';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Performance Analyzer',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xfff5f7fb),
        fontFamily: 'Arial',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.indigo,
        fontFamily: 'Arial',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DashboardScreen(
          subjects: subjects,
          averageMarks: averageMarks,
          averageAttendance: averageAttendance,
          overallGrade: overallGrade,
          overallStatus: overallStatus,
          isDarkMode: isDarkMode,
          onThemeChanged: toggleTheme,
        ),
        '/add': (context) => AddPerformanceScreen(onAdd: addSubject),
        '/subjects': (context) =>
            SubjectsScreen(subjects: subjects, onDelete: removeSubject),
        '/insights': (context) => InsightsScreen(
          subjects: subjects,
          averageMarks: averageMarks,
          averageAttendance: averageAttendance,
          overallGrade: overallGrade,
          overallStatus: overallStatus,
        ),
      },
    );
  }
}

// ------------------------------------------------------------
// DASHBOARD
// ------------------------------------------------------------

class DashboardScreen extends StatelessWidget {
  final List<SubjectPerformance> subjects;
  final double averageMarks;
  final double averageAttendance;
  final String overallGrade;
  final String overallStatus;
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const DashboardScreen({
    super.key,
    required this.subjects,
    required this.averageMarks,
    required this.averageAttendance,
    required this.overallGrade,
    required this.overallStatus,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Performance Analyzer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'theme') {
                onThemeChanged();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                    const SizedBox(width: 10),
                    Text(isDarkMode ? 'Light Mode' : 'Dark Mode'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(isDarkMode: isDarkMode, onThemeChanged: onThemeChanged),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, Student 👋',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Track your academic progress in one place.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),

            // Overall Performance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overall Performance',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${averageMarks.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$overallStatus • Grade $overallGrade',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Subjects',
                    value: '${subjects.length}',
                    icon: Icons.menu_book,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Attendance',
                    value: '${averageAttendance.toStringAsFixed(0)}%',
                    icon: Icons.calendar_month,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Average',
                    value: '${averageMarks.toStringAsFixed(1)}%',
                    icon: Icons.analytics,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Grade',
                    value: overallGrade,
                    icon: Icons.grade,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            ActionCard(
              icon: Icons.add_chart,
              title: 'Add Performance',
              subtitle: 'Enter marks and attendance',
              onTap: () {
                Navigator.pushNamed(context, '/add');
              },
            ),

            const SizedBox(height: 12),

            ActionCard(
              icon: Icons.library_books,
              title: 'View Subjects',
              subtitle: 'See all subject performance',
              onTap: () {
                Navigator.pushNamed(context, '/subjects');
              },
            ),

            const SizedBox(height: 12),

            ActionCard(
              icon: Icons.insights,
              title: 'View Insights',
              subtitle: 'Understand your performance',
              onTap: () {
                Navigator.pushNamed(context, '/insights');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// STAT CARD
// ------------------------------------------------------------

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// ACTION CARD
// ------------------------------------------------------------

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(radius: 25, child: Icon(icon)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// ------------------------------------------------------------
// ADD PERFORMANCE
// ------------------------------------------------------------

class AddPerformanceScreen extends StatefulWidget {
  final Function(SubjectPerformance) onAdd;

  const AddPerformanceScreen({super.key, required this.onAdd});

  @override
  State<AddPerformanceScreen> createState() => _AddPerformanceScreenState();
}

class _AddPerformanceScreenState extends State<AddPerformanceScreen> {
  final TextEditingController subjectController = TextEditingController();

  final TextEditingController marksController = TextEditingController();

  final TextEditingController attendanceController = TextEditingController();

  void savePerformance() {
    final subject = subjectController.text.trim();
    final marks = double.tryParse(marksController.text);
    final attendance = double.tryParse(attendanceController.text);

    if (subject.isEmpty ||
        marks == null ||
        attendance == null ||
        marks < 0 ||
        marks > 100 ||
        attendance < 0 ||
        attendance > 100) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid Input'),
            content: const Text('Please enter valid values between 0 and 100.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      return;
    }

    widget.onAdd(
      SubjectPerformance(name: subject, marks: marks, attendance: attendance),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    subjectController.dispose();
    marksController.dispose();
    attendanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Performance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.analytics, size: 60),
            const SizedBox(height: 15),
            Text(
              'Enter Subject Details',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add your marks and attendance to analyze your progress.',
            ),
            const SizedBox(height: 30),

            TextField(
              controller: subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject Name',
                hintText: 'Example: Artificial Intelligence',
                prefixIcon: Icon(Icons.book),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: marksController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Marks',
                hintText: '0 - 100',
                prefixIcon: Icon(Icons.score),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: attendanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Attendance %',
                hintText: '0 - 100',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: savePerformance,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Save Performance',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// SUBJECTS SCREEN
// ------------------------------------------------------------

class SubjectsScreen extends StatelessWidget {
  final List<SubjectPerformance> subjects;
  final Function(int) onDelete;

  const SubjectsScreen({
    super.key,
    required this.subjects,
    required this.onDelete,
  });

  Color getStatusColor(BuildContext context, String status) {
    if (status == 'Excellent') {
      return Colors.green;
    }

    if (status == 'Good') {
      return Colors.blue;
    }

    if (status == 'Average') {
      return Colors.orange;
    }

    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subject Performance',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: subjects.isEmpty
          ? const Center(
              child: Text(
                'No subjects added yet.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];

                final statusColor = getStatusColor(context, subject.status);

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: Text(
                                subject.grade,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    subject.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Attendance: ${subject.attendance.toStringAsFixed(0)}%',
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                onDelete(index);
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        LinearProgressIndicator(
                          value: subject.marks / 100,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(10),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${subject.marks.toStringAsFixed(0)} / 100',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                subject.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ------------------------------------------------------------
// INSIGHTS SCREEN
// ------------------------------------------------------------

class InsightsScreen extends StatelessWidget {
  final List<SubjectPerformance> subjects;
  final double averageMarks;
  final double averageAttendance;
  final String overallGrade;
  final String overallStatus;

  const InsightsScreen({
    super.key,
    required this.subjects,
    required this.averageMarks,
    required this.averageAttendance,
    required this.overallGrade,
    required this.overallStatus,
  });

  SubjectPerformance? get highestSubject {
    if (subjects.isEmpty) return null;

    SubjectPerformance highest = subjects.first;

    for (final subject in subjects) {
      if (subject.marks > highest.marks) {
        highest = subject;
      }
    }

    return highest;
  }

  SubjectPerformance? get lowestSubject {
    if (subjects.isEmpty) return null;

    SubjectPerformance lowest = subjects.first;

    for (final subject in subjects) {
      if (subject.marks < lowest.marks) {
        lowest = subject;
      }
    }

    return lowest;
  }

  @override
  Widget build(BuildContext context) {
    final highest = highestSubject;
    final lowest = lowestSubject;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Performance Insights',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Analysis',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              'A simple overview of your current academic performance.',
            ),

            const SizedBox(height: 24),

            InsightCard(
              icon: Icons.emoji_events,
              title: 'Overall Grade',
              value: overallGrade,
              subtitle: overallStatus,
            ),

            const SizedBox(height: 12),

            InsightCard(
              icon: Icons.percent,
              title: 'Average Marks',
              value: '${averageMarks.toStringAsFixed(1)}%',
              subtitle: 'Across ${subjects.length} subjects',
            ),

            const SizedBox(height: 12),

            InsightCard(
              icon: Icons.event_available,
              title: 'Average Attendance',
              value: '${averageAttendance.toStringAsFixed(1)}%',
              subtitle: averageAttendance >= 75
                  ? 'Attendance requirement met'
                  : 'Attendance needs attention',
            ),

            const SizedBox(height: 24),

            if (highest != null)
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.trending_up)),
                  title: const Text('Strongest Subject'),
                  subtitle: Text(highest.name),
                  trailing: Text(
                    '${highest.marks.toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            if (lowest != null)
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.trending_down)),
                  title: const Text('Subject to Improve'),
                  subtitle: Text(lowest.name),
                  trailing: Text(
                    '${lowest.marks.toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline),
                  const SizedBox(height: 10),
                  const Text(
                    'Tip',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    averageAttendance < 75
                        ? 'Focus on improving attendance while maintaining your marks.'
                        : averageMarks < 60
                        ? 'Spend more study time on subjects with lower marks.'
                        : 'Keep your current study routine and continue improving.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// INSIGHT CARD
// ------------------------------------------------------------

class InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const InsightCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(radius: 28, child: Icon(icon)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// DRAWER
// ------------------------------------------------------------

class AppDrawer extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeChanged;

  const AppDrawer({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Student Performance Analyzer'),
            accountEmail: const Text('Track • Analyze • Improve'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),

          ListTile(
            leading: const Icon(Icons.add_chart),
            title: const Text('Add Performance'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/add');
            },
          ),

          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Subjects'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/subjects');
            },
          ),

          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text('Insights'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/insights');
            },
          ),

          const Divider(),

          SwitchListTile(
            secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              onThemeChanged();
            },
          ),

          const Divider(),

          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            subtitle: Text('Student Performance Analyzer v1.0'),
          ),
        ],
      ),
    );
  }
}
