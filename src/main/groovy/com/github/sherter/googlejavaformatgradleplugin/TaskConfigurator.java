package com.github.sherter.googlejavaformatgradleplugin;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableListMultimap;
import com.google.common.collect.Iterables;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Collections;
import org.gradle.api.file.FileTree;
import org.gradle.api.tasks.util.PatternSet;

class TaskConfigurator {

  private final SharedContext context;

  TaskConfigurator(SharedContext context) {
    this.context = context;
  }

  void configureFormatTask(FormatTask task) {
    task.sharedContext = context;
    if (!task.hasSources()) {
      task.setSource(context.getExtension().getSource());
    }
    String value = System.getProperty(task.getName() + ".include");
    if (value != null) {
      String[] patterns = value.split(",");
      FileTree filteredSources = task.getSource().matching(new PatternSet().include(patterns));
      task.setSource(filteredSources);
    }
  }

  void configure(GoogleJavaFormat task) {
    configureFormatTask(task);
    ImmutableListMultimap<FileState, Path> mapping =
        context.mapper().reverseMap(Utils.toPaths(task.getSource().getFiles()));
    task.setFormattedSources(mapping.get(FileState.FORMATTED));
    task.setInvalidSources(new ArrayList<>(mapping.get(FileState.INVALID)));
    ImmutableList<Path> unformatted = mapping.get(FileState.UNFORMATTED);
    ImmutableList<Path> unknown = mapping.get(FileState.UNKNOWN);
    if (Iterables.size(task.getInvalidSources())
            + Iterables.size(unformatted)
            + Iterables.size(unknown)
        == 0) {
      // task is up-to-date, make sure it is skipped
      task.setSource(Collections.emptyList());
    } else {
      task.setFilteredSources(Iterables.concat(unformatted, unknown));
    }
  }

  void configure(VerifyGoogleJavaFormat task) {
    configureFormatTask(task);
  }
}
